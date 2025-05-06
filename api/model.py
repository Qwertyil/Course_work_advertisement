from database.select import select_list


def model(db_config, user_data, sql_provider):
    _sql = ''

    if 'username' in user_data:
        _sql = sql_provider.get('external_auth.sql', login=user_data['username'], password=user_data['password'])
    print(_sql)
    result = select_list(db_config, _sql)

    return result
