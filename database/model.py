import os
import json

from database.DBcm import DBContextManager
from database.SQLProvider import SQLProvider
from database.select import select_list


path = os.path.join(os.path.abspath(os.getcwd()), 'database', 'sql')
sql_provider = SQLProvider(path)

with open('data/db_config.json') as f:
    db_config = json.load(f)


def get_user(login, password):
    _sql = sql_provider.get('select_user.sql', login=login, password=password)
    result = select_list(db_config, _sql)

    # Если запрос вернул данные - возвращаем их
    if type(result) is not int and result:
        # Возвращаем первую строку, которую вернул запрос (т.к. пароль и логин уникальны строка будет всего одна)
        return result[0]

    # Если же во время выполнения запроса произошла ошибка, возвращаем ее (подробнее о кодах ошибок в select_list)
    else:
        return result


def queries_model(query_number, **kwargs):
    # Название sql файлов всех запросов должно иметь такой вид
    file = 'query' + str(query_number) + '.sql'

    _sql = sql_provider.get(file, **kwargs)

    result = select_list(db_config, _sql)

    return result


def reports_create_model(report_number, month, year):
    file = 'report_creator.sql'

    _sql = sql_provider.get(file, number=report_number, month=month, year=year)

    result = select_list(db_config, _sql)

    return result


def reports_view_model(report_number, month, year):
    file = 'report_viewer.sql'

    _sql = sql_provider.get(file, number=report_number, month=month, year=year)

    result = select_list(db_config, _sql)

    return result


def get_billboards(start, end):
    file = 'get_billboards.sql'

    _sql = sql_provider.get(file, start=start, end=end)
    print(_sql)
    result = select_list(db_config, _sql)

    return result


def finish_rent(user_id, start_date, end_date, billboards):
    with DBContextManager(db_config) as cursor:
        if cursor is None:
            raise ValueError("Cursor not created")
        # Создадим заказ
        sql = sql_provider.get('create_order.sql', rentor_id=user_id)
        cursor.execute(sql)
        # Получим его ID
        sql = sql_provider.get('get_order_id.sql', rentor_id=user_id)
        cursor.execute(sql)
        order_id = cursor.fetchall()[0][0]
        # Теперь добавим строки этого заказа в таблицу строк
        for i in billboards:
            sql = sql_provider.get('new_string.sql', start=start_date, end=end_date, billboard_id=i, order_id=order_id)
            cursor.execute(sql)
        # Если во время создания заказа произошла ошибка (например при добавлении некоторой строки)
        # То происходит rollback, и все уже внесенные изменения откатываются

        # А если нет то возвращается id заказа
        return order_id
