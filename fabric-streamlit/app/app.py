import streamlit as st
import pandas as pd
import pyodbc
import time

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
    st.write(f"Connecting to Fabric...")

    service_principal_id = "<>"
    service_principal_password = "<>"

    server_name = "<>"

    database_name = "lkstreamlit"

    # Define the SQL Server ODBC connection string
    conn_str = (
        f"DRIVER=<>"
        f"SERVER={server_name};"
        f"DATABASE={database_name};"
        f"UID={service_principal_id};"
        f"PWD={service_principal_password};"
        f"Authentication=ActiveDirectoryServicePrincipal"
    )

    # Establish the connection
    conn = pyodbc.connect(conn_str)
    end_time = time.time()
    conn_time = end_time - start_time
    st.write(f"✅ Connection successfully established in {conn_time} seconds")

    query = st.text_area("Enter your SQL query:", height=200)

    if st.button("Run Query"):
        if not query.strip():
            st.error("Query cannot be empty. Please enter a valid SQL query.")
        else:

            with st.spinner("Executing query..."):
                result_df, execution_time = execute_query(query, conn)

                num_rows = 5
                st.write(f"Showing the first {num_rows} rows:")
                st.write(result_df.head(num_rows))

                st.write(f"Time taken to execute the query: {execution_time} seconds")

if __name__ == "__main__":
    main()