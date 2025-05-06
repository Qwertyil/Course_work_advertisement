import json

from functools import wraps

from flask import session, request, render_template


with open('data/db_access.json') as f:
    access = json.load(f)


# Декоратор для проверки того, авторизован ли пользователь и имеет ли он права на выбранный blueprint
def group_required(func):

    @wraps(func)
    def wrapper(*args, **kwargs):
        if 'user_role' in session:
            user_role = session.get('user_role')
            user_request = request.endpoint
            user_bp = user_request.split('.')[0]
            # Проверяем есть ли группа пользователя в data/db_access.json
            # И есть ли у него права доступа к выбранному им варианту использования
            if user_role in access and access[user_role][user_bp] != ["-"]:
                return func(*args, **kwargs)
            return render_template('message.html', message='У вас недостаточно прав на эту функциональность')
        return render_template('message.html', message='Сначала необходимо авторизоваться')

    return wrapper


# Данный декоратор использует декоратор group_required в себе, чтобы сначала проверить авторизован ли пользователь
# Если пользователь авторизован, потом проверяются его права на выбранный запрос
# В нем используется то, что в URL содержится номер запроса.
# Если изменить то, что URL заканчивается номером запроса, данный декоратор тоже нужно будет изменить.
def check_query_access(func):

    @wraps(func)
    def wrapper(*args, **kwargs):
        group_required(func)(*args, **kwargs)
        # Берем из сессии роль пользователя
        user_role = session.get('user_role')
        # Достаем из URL номер запроса, запрашиваемый пользователем
        query = int(request.url.split('/')[-1])
        # И проверяем есть ли у пользователя права выбранный запрос
        if (user_role in access) and (query in access[user_role]['query'] or access[user_role]['query'] == ['*']):
            return func(*args, **kwargs)
        return render_template('message.html', message='Недостаточно прав на выполнение выбранного запроса')
    return wrapper


def get_user_accessible_queries():
    """
    Функция возвращает список номеров всех запросов, доступных пользователю
    """
    return [i for i in access[session['user_role']]['query']]


def check_report_action_access(action):
    """
    Функция проверяет, имеет ли пользователь право на выбранное действие (просмотр или создание отчета)
    при работе с отчетами
    """
    return action in access[session['user_role']]['report']
