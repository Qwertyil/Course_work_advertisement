from database.DBcm import DBContextManager as DBcm


def select_list(db_config, sql):
    """
    Функция принимает конфиг БД и sql-запрос, выполняет sql-запрос и возвращает его результат
    Если произошла ошибка возвращаются специальные целочисленные коды:
    1 - Ошибка при попытке соединения с базой данных
    2 - sql-запрос не вернул результатов
    None - Ошибка при выполнении sql-запроса
    """
    with DBcm(db_config) as cursor:

        if cursor is None:
            return 1

        cursor.execute(sql)
        result = cursor.fetchall()

        if not result:
            return 2

        return result


def select_list_with_schema(db_config: dict, _sql: str):
    # порядок работы конструкции with
    # инициируются переменные (cursor) в методе __init__
    # управление передаётся методу __enter__
    # создаётся курсор или ничего, все дела
    # возвращение управления вызвавшей функции
    # если курсор не был создан, то создаётся ошибка ValueError
    # выполняются все действия в функции, если возникает ошибка, то вызывается метод __error__

    result = ()
    schema = []
    with DBcm(db_config) as cursor:
        if cursor is None:
            raise ValueError("Cursor not created")

        cursor.execute(_sql)
        result = cursor.fetchall()

        schema = [item[0] for item in cursor.description]

    return result, schema


def select_dict(db_config: dict, _sql: str):
    result, schema = select_list_with_schema(db_config, _sql)
    result_dict = []
    for item in result:
        result_dict.append(dict(zip(schema, item)))

    return result_dict
