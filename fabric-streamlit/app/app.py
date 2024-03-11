import streamlit as st
import pandas as pd
import pyodbc
import time
import sqlalchemy as sa
from sqlalchemy.engine import URL

#def execute_query(query, conn):
#    start_time = time.time()
#    df = pd.read_sql(query, conn)
#    end_time = time.time()
#    query_time = end_time - start_time
#    return df, query_time

def execute_query(query, conn):
    start_time = time.time()
    result_df = pd.read_sql(query, conn)
    end_time = time.time()
    query_time = end_time - start_time
    
    return result_df, query_time

def print_query(query, conn):
    st.write(f"-----------------")
    st.write(f"Query: `{query}`")

    result_df, execution_time = execute_query(query, conn)

    rows_to_display = 5 
    st.write(f"Showing the first {rows_to_display} rows:")
    st.write(result_df.head(rows_to_display))

    st.write(f"Time taken to execute the query: {execution_time} seconds")

def main():
    st.title("fabric-odbc sql endpoint")

    start_time = time.time()
    #st.write(f"Connecting to Fabric...")

    data = {
        'name': ['Alice', 'Bob', 'Charlie', 'David'],
        'age': [25, 30, 35, 40]
    }

    # Creating DataFrame
    df = pd.DataFrame(data)

    service_principal_id = "7fd00ca9-7827-482c-926f-222cc1bb0efd"
    service_principal_password = "ZmE8Q~TjS80DGhNNwiSllIhNIZTM2XfbZk2JYaer"

    server_name = "fc2fvmfg57luhpz3o72xauoutm-66v6qnkrf4ce3phenbrjtha2du.datawarehouse.pbidedicated.windows.net"
    driver_path = "/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.10.so.5.1"

    database_name = "whstreamlit"

    st.write(f"Writing from Streamlit...")
    connection_string = f"DRIVER={driver_path};SERVER={server_name};DATABASE={database_name};UID={service_principal_id};PWD={service_principal_password};Authentication=ActiveDirectoryServicePrincipal"
    connection_url = URL.create("mssql+pyodbc", query={"odbc_connect": connection_string})
    #engine = sa.create_engine(f'mssql+pyodbc://{service_principal_id}:{service_principal_password}@{server_name}/{database_name}?driver={driver_path}')
    engine = sa.create_engine(connection_url)
    end_time = time.time()
    conn_time = end_time - start_time
    st.write(f"✅ Connection successfully established in {conn_time} seconds")
    df.to_sql("streamlit_write1", engine, schema="dbo", if_exists='append', index=False)

    # Define the SQL Server ODBC connection string
    conn_str = (
        f"DRIVER=/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.10.so.5.1;"
        f"SERVER={server_name};"
        f"DATABASE={database_name};"
        f"UID={service_principal_id};"
        f"PWD={service_principal_password};"
        f"Authentication=ActiveDirectoryServicePrincipal"
    )

    # Establish the connection
    #conn = pyodbc.connect(conn_str)
    #end_time = time.time()
    #conn_time = end_time - start_time
    #st.write(f"✅ Connection successfully established in {conn_time} seconds")

    #query = st.text_area("Enter your SQL query:", height=200)

    #if st.button("Run Query"):
    #    if not query.strip():
    #        st.error("Query cannot be empty. Please enter a valid SQL query.")
    #    else:
    #
    #        with st.spinner("Executing query..."):
    #            result_df, execution_time = execute_query(query, conn)
    #
    #            num_rows = 5
    #            st.write(f"Showing the first {num_rows} rows:")
    #            st.write(result_df.head(num_rows))
    #
    #            st.write(f"Time taken to execute the query: {execution_time} seconds")

if __name__ == "__main__":
    main()