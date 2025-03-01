from typing import Dict

import requests
from pandas import DataFrame, read_csv, read_json, to_datetime

def temp() -> DataFrame:
    """Get the temperature data.
    Returns:
        DataFrame: A dataframe with the temperature data.
    """
    return read_csv("data/temperature.csv")

def get_public_holidays(public_holidays_url: str, year: str) -> DataFrame:
    """Get the public holidays for the given year for Brazil.
    Args:
        public_holidays_url (str): url to the public holidays.
        year (str): The year to get the public holidays for.
    Raises:
        SystemExit: If the request fails.
    Returns:
        DataFrame: A dataframe with the public holidays.
    """
    

    #************************************
    url = f"{public_holidays_url}/{year}/BR"
    # Construye la URL para la API de días festivos.
    # public_holidays_url: URL base de la API.
    # year: Año para el cual se obtienen los días festivos.
    # /BR: Especifica que se obtienen los días festivos de Brasil.
    # Resultado: Una URL completa para la solicitud a la API.
    
    # Bloque de excepción
    try:
        response = requests.get(url)
        # Realiza una solicitud GET a la URL usando la biblioteca requests.
        # Almacena la respuesta de la API en la variable response.
        response.raise_for_status()
        # Verifica si la solicitud fue exitosa.
        # Lanza una excepción si la solicitud falla.
        data = response.json()
        # Convierte la respuesta JSON a un diccionario de Python.
    except requests.exceptions.RequestException as e:
        # Captura excepciones si ocurre un error durante la solicitud.
        print(f"Error al obtener datos de la API: {e}")
        # Imprime un mensaje de error con la excepción capturada.
        raise SystemExit(f"Error al obtener datos de la API: {e}")
        # Termina la ejecución del programa debido a un error en la solicitud.

    holidays_df = DataFrame(data)
    # Crea un DataFrame de pandas a partir del diccionario de Python (datos JSON).

    if "types" in holidays_df.columns:
        # Verifica si la columna "types" existe en el DataFrame.
        holidays_df = holidays_df.drop(columns=["types"])
        # Elimina la columna "types" del DataFrame si existe.
    if "counties" in holidays_df.columns:
        # Verifica si la columna "counties" existe en el DataFrame.
        holidays_df = holidays_df.drop(columns=["counties"])
        # Elimina la columna "counties" del DataFrame si existe.


    holidays_df["date"] = to_datetime(holidays_df["date"])
    # Convierte la columna "date" a tipo datetime usando la función to_datetime de pandas.

    print(url)
    # Imprime la URL utilizada para obtener los datos de la API.
    return holidays_df
    # Retorna el DataFrame con los datos de los días festivos.
    
    #**************************************

    

def extract(
    csv_folder: str, csv_table_mapping: Dict[str, str], public_holidays_url: str
) -> Dict[str, DataFrame]:
    """Extract the data from the csv files and load them into the dataframes.
    Args:
        csv_folder (str): The path to the csv's folder.
        csv_table_mapping (Dict[str, str]): The mapping of the csv file names to the
        table names.
        public_holidays_url (str): The url to the public holidays.
    Returns:
        Dict[str, DataFrame]: A dictionary with keys as the table names and values as
        the dataframes.
    """
    dataframes = {
        table_name: read_csv(f"{csv_folder}/{csv_file}")
        for csv_file, table_name in csv_table_mapping.items()
    }

    holidays = get_public_holidays(public_holidays_url, "2017")

    dataframes["public_holidays"] = holidays
    
    return dataframes
