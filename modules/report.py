"""
Blueprint для работы с отчетами
Информация об отчетах находится в data/report.json
В этом файле находится словарь с записями вида:

"<Номер отчета>": {
    "description": "...",
    "response_description": "...",
    "column_names": [...]
}

Для каждого отчета:
    - description - описание отчета;
      оно отображается на странице со списком отчетов и на странице для ввода года и месяца этого отчета
    - response_description - f-строка python для описания запроса с введенными параметрами;
      отображается на странице с результатами отчета;
      количество и названия параметров должны совпадать с количеством и названиями вводимых пользователем параметров;
      впрочем, реализован только ввод месяца и года для каждого отчета, а значит в строке 2 параметра - month и year
    - column_names - названия столбцов, возвращаемых sql-запросом

Как создать новый отчет:
    1) Добавить новую запись в data/report.json
    2) Создать таблицу в БД для хранения этих отчетов;
    имя таблицы "report<number>"; в самой таблице обязательны 2 ПЕРВЫХ поля: report_year int и report_month int
    3) Создать процедуру для создания этого отчета в БД;
    название процедуры должно иметь вид report<number>_creator;
    также она должна принимать 2 аргумента: год и месяц, за которые отчет создается.
    Процедура обязана всегда возвращать 1 из 3 значений:
        1. report already exists - если отчет за заданный месяц уже существует
        2. nothing to create a report from - нет данных для создания такого отчета
        3. report successfully created - отчет успешно создан

Заключительные замечания:
    - Номер отчета всегда должен являться десятичным числом
    - Права групп пользователей на создание/просмотр отчета определяются в data/db_access.json
"""
from flask import Blueprint, render_template, request, json

import access
from database.model import reports_create_model, reports_view_model


report = Blueprint('report', __name__, template_folder='templates')


with open('data/report.json', 'rb') as f:
    x = f.read()
    x = x.decode('utf-8')
    reports = json.loads(x)


@report.route('/')
@access.group_required
def index():
    """
    Функция, возвращающая список отчетов и страницы для ввода параметров конкретного отчета
    """
    reports_descriptions = {k: v['description'] for k, v in reports.items()}
    return render_template('report_index.html', reports=reports_descriptions)


@report.route('/<int:num>', methods=['GET', 'POST'])
@access.group_required
def report_selected(num):
    """
    Попадаем в эту функцию после выборе отчета из списка
    num - номер выбранного отчета
    """
    if str(num) not in reports:
        return render_template('message.html', message='Отчета с таким номером не существует')

    if request.method == 'GET':
        report_data = reports[str(num)]
        description = report_data['description']

        return render_template('report_args.html', report_number=num, description=description)

    if request.method == 'POST':
        action = request.form.get('action')
        month = request.form.get('month')
        year = request.form.get('year')

        if not access.check_report_action_access(action):
            return render_template('message.html', message='Недостаточно прав на данное действие')

        if action == 'create':
            return report_creator(num, month, year)

        if action == 'view':
            return report_viewer(num, month, year)


def report_creator(number, month, year):
    """
    Функция для создания отчетов
    В ней вызывается reports_create_model, а затем проверяется возвращенный результат
    Если результат:
    None - произошла ошибка в БД
    1 - не удалось подключиться к БД
    следующие 3 результата - значения, возвращаемые вызываемой процедурой
    для совместимости процедуры для будущих отчетов должны возвращать те же значения

    (Код ошибки 2: sql-запрос не вернул данных в данной ситуации невозможен,
    т. к. процедура всегда возвращает какое-либо значение)
    """
    result = reports_create_model(number, month, year)

    if not result:
        return render_template('message.html', message='Произошла ошибка')

    if result == 1:
        return render_template('message.html', message='Возникла ошибка при подключении к БД')

    if result[0][0] == 'report already exists':
        return render_template('message.html', message='Отчет уже существует')

    if result[0][0] == 'nothing to create a report from':
        return render_template('message.html', message='Нет данных для создания отчета')

    if result[0][0] == 'report successfully created':
        return render_template('message.html', message='Отчет успешно создан')

    else:
        return render_template('message.html', message='Процедура вернула непредвиденное значение')


def report_viewer(number, month, year):
    """
    Функция для просмотра отчетов
    В ней вызывается reports_view_model, а затем проверяется возвращенный результат
    Если результат:
    None - произошла ошибка в БД
    1 - не удалось подключиться к БД
    2 - sql-запрос не вернул результатов; отчета за данный месяц не существует
    """
    result = reports_view_model(number, month, year)

    if not result:
        return render_template('message.html', message='Произошла ошибка')

    if result == 1:
        return render_template('message.html', message='Возникла ошибка при подключении к БД')

    if result == 2:
        return render_template('message.html', message='Такого отчета не существует')

    else:
        # Преобразуем номер месяца в его название
        month = month_number_to_month_name_converter[int(month)]

        # Получаем описание отчета и возвращаемые столбцы (задаются в report.json)
        description = reports[str(number)]['response_description'].format(year=year, month=month)
        column_names = reports[str(number)]['column_names']

        # Отбрасываем первые 2 поля в каждой строке, которую вернул запрос
        # Эти строки содержат год и месяц отчета (см. документацию модуля)
        rows = [i[2:] for i in result]

        return render_template(f'query_response.html', rows=rows,
                               column_names=column_names, description=description)


month_number_to_month_name_converter = {
    1: 'январе', 2: 'феврале',
    3: 'марте', 4: 'апреле', 5: 'мае',
    6: 'июне', 7: 'июле', 8: 'августе',
    9: 'сентябре', 10: 'октябре', 11: 'ноябре',
    12: 'декабре'
}