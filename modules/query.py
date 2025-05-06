"""
Blueprint для работы с запросами
Информация о запросах находится в data/query.json
В этом файле находится словарь с записями вида:

"<Номер запроса>": {
    "description": "...",
    "response_description": "...",
    "column_names": [...],
    "parameters": {
        "number": [["...", "..."], ["...", "..."], ..., ["...", "..."]],
        "month": [...]
    }
}

Для каждого запроса:
    - description - описание запроса;
      оно отображается на странице с запросами и на странице для ввода параметров этого запроса
    - response_description - f-строка python для описания запроса с введенными параметрами;
      отображается на странице с результатами запроса;
      количество и названия параметров должны совпадать с количеством и названиями вводимых пользователем параметров (о них ниже)
    - column_names - названия столбцов, возвращаемых sql-запросом
    - parameters - словарь, ключами которого являются названия полей для ввода, а значениями списки двухэлементных списков;
      тут определяются количество полей для ввода этого запроса, их типы и названия
      узнать обо всех доступных типах полей для ввода можно в templates/query_args.
      Каждый двухэлементный список в списке конкретного названия поля ввода содержит:
      1) id и name этого поля ввода; то есть то, с каким названием введенный параметр будет возвращен обратно в POST-запросе после нажатия кнопки "Отправить"
      2) Надпись, которая будет написана над этим полем ввода на странице ввода параметров этого запроса

Как создать новый запрос:
    1) Добавить новую запись в data/query.json
    2) Создать файл с sql-запросом в database/sql

Заключительные замечания:
    - Номер запроса всегда должен являться десятичным числом
    - Для каждого запроса в каталоге database/sql должен существовать sql-запрос с названием "query<Номер запроса>.sql"
    - Права групп пользователей на запросы определяются в data/db_access.json
    - Если определенных в templates/query_args типов полей ввода недостаточно, их всегда можно туда добавить
"""
from flask import Blueprint, render_template, request, json

import access

from database.model import queries_model


query = Blueprint('query', __name__, template_folder='templates')


with open('data/query.json', 'rb') as f:
    x = f.read()
    x = x.decode('utf-8')
    queries = json.loads(x)


@query.route('/', methods=['GET'])
@access.group_required
def index():
    """
    Попадаем в эту функцию при нажатии кнопки "Работа с запросами" в главном меню
    """

    # Для начала получаем список запросов к которым есть доступ у пользователя (задается в config/db_access.json)
    user_accessible_queries = access.get_user_accessible_queries()

    # Затем получаем всю информацию о данных запросах
    if user_accessible_queries != ["*"]:
        user_queries = {k: v['description'] for k, v in queries.items() if int(k) in user_accessible_queries}
    else:
        user_queries = {k: v['description'] for k, v in queries.items()}

    # Далее на основе этого списка рендерим страницу со списком запросов
    return render_template('query_index.html', queries=user_queries)


@query.route('/<int:num>', methods=['GET'])
@access.check_query_access
def query_parameters(num):
    """
    Попадаем в эту функцию после выборе запроса из списка
    num - номер выбранного запроса
    """

    # Проверяем есть ли запрос с таким номером в data/query.json
    if str(num) not in queries:
        return render_template('message.html', message='Такого запроса не существует')

    query_data = queries[str(num)]
    description = query_data['description']
    parameters = query_data['parameters']

    return render_template('query_args.html', query_number=num, description=description, parameters=parameters)


@query.route('/<int:num>', methods=['POST'])
@access.check_query_access
def query_response(num):
    """
    Попадаем в эту функцию после ввода параметров запроса
    num - номер выбранного запроса
    """

    # Получаем номер запроса
    query_data = queries[str(num)]

    # Переносим в args параметры, введенные пользователем
    args = request.form.to_dict()

    # Если в параметрах запроса был месяц, то преобразуем его номер в название этого месяца
    # для отображения на странице с результатами
    if 'month' in args:
        args['month'] = month_number_to_month_name_converter[int(args['month'])]

    # Достаем описание запроса с введенными параметрами (которое находится над таблицей)
    # и вставляем в него введенные пользователем параметры
    description = query_data['response_description'].format(**args)

    # Достаем названия столбцов, извлекаемых запросом
    column_names = query_data['column_names']

    # Выполняем запрос в БД
    result = queries_model(num, **request.form)

    # Проверяем результат запроса
    # (подробнее о возможных результатах в database/select/select_list и database/model/queries_model)
    if not result:
        return render_template('message.html', message='Возникла ошибка. Проверьте правильность SQL запроса')

    if result == 1:
        return render_template('message.html', message='Возникла ошибка при подключении к БД')

    if result == 2:
        return render_template('message.html', message='Запрос не вернул результатов')

    # Если ошибок не возникло возвращаем таблицу результатов
    return render_template('query_response.html', column_names=column_names,
                           description=description, rows=result)


month_number_to_month_name_converter = {
    1: 'январе', 2: 'феврале',
    3: 'марте', 4: 'апреле', 5: 'мае',
    6: 'июне', 7: 'июле', 8: 'августе',
    9: 'сентябре', 10: 'октябре', 11: 'ноябре',
    12: 'декабре',
}
