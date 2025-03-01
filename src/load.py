from typing import Dict

from pandas import DataFrame
from sqlalchemy.engine.base import Engine


def load(data_frames: Dict[str, DataFrame], database: Engine):
    """Load the dataframes into the sqlite database.

    Args:
        data_frames (Dict[str, DataFrame]): A dictionary with keys as the table names
        and values as the dataframes.
    """
    
    

    for table_name, df in data_frames.items():
        # Inicia un bucle 'for' que itera a través de los ítems (pares clave-valor) del diccionario 'data_frames'.
        # 'data_frames' es un diccionario donde:
        #   - Las claves ('table_name') son los nombres de las tablas que se crearán/reemplazarán en la base de datos.
        #   - Los valores ('df') son los DataFrames de pandas que contienen los datos a cargar.

        df.to_sql(table_name, con=database, if_exists='replace', index=False)
        # Utiliza el método 'to_sql' del DataFrame 'df' para cargar los datos en la base de datos.
        # 'table_name': El nombre de la tabla en la base de datos (obtenido de la clave del diccionario).
        # 'con=database': La conexión a la base de datos (un objeto Engine de SQLAlchemy).
        # 'if_exists='replace'': Especifica que si la tabla ya existe, debe ser reemplazada por una nueva tabla con los datos del DataFrame.
        # 'index=False': Indica que el índice del DataFrame no debe ser escrito como una columna en la tabla de la base de datos.