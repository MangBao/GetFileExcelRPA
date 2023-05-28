*** Settings ***
Documentation       Insert the sales data for the week and export it as a PDF.

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.Excel.Files
Library             RPA.HTTP
Library             RPA.PDF
Library             RPA.Tables


*** Variables ***
${DOWNLOAD_PATH}=       ${CURDIR}${/}resources${/}input_data
${SALES_FILE_URL}=      https://robotsparebinindustries.com/SalesData.xlsx
${ORDER_FILE_URL}=      https://robotsparebinindustries.com/orders.csv


*** Tasks ***
Insert the sales data for the week and export it as a PDF
    Open the intranet website
    Log in
    Download the Sales file
    # Download the Orders file
    Fill the form using the data from the Sales file
    # Fill the form using the data from the Orders file
    Collect the results
    Export the table as a PDF
    [Teardown]    Log out and close the browser


*** Keywords ***
Open the intranet website
    Open Available Browser    https://robotsparebinindustries.com/

Log in
    Input Text    username    maria
    Input Password    password    thoushallnotpass
    Submit Form
    Wait Until Page Contains Element    id:sales-form

Download the Sales file
    Download    ${SALES_FILE_URL}    target_file=${DOWNLOAD_PATH}    overwrite=True

Download the Orders file
    Download    ${ORDER_FILE_URL}    target_file=${DOWNLOAD_PATH}    overwrite=True

Fill and submit the form for one person
    [Arguments]    ${sales_rep}
    Input Text    firstname    ${sales_rep}[First Name]
    Input Text    lastname    ${sales_rep}[Last Name]
    Input Text    salesresult    ${sales_rep}[Sales]
    Select From List By Value    salestarget    ${sales_rep}[Sales Target]
    Click Button    Submit

Fill the form using the data from the Sales file
    ${file_name}=    Set Variable    SalesData.xlsx
    ${sales}=    Get file ${file_name}
    FOR    ${sale}    IN    @{sales}
        Fill and submit the form for one person    ${sale}
    END

Fill the form using the data from the Orders file
    ${orders}=    Read table from CSV    ${DOWNLOAD_PATH}${/}orders.csv
    Log To Console    \n
    FOR    ${order}    IN    @{orders}
        Log To Console    ${order}
    END

Get file ${file_name}
    Open Workbook    ${DOWNLOAD_PATH}${/}${file_name}
    ${file_res}=    Read Worksheet As Table    header=True
    Close Workbook
    RETURN    ${file_res}

Collect the results
    Screenshot    css:div.sales-summary    ${OUTPUT_DIR}${/}sales_summary.png

Export the table as a PDF
    Wait Until Element Is Visible    id:sales-results
    ${sales_results_html}=    Get Element Attribute    id:sales-results    outerHTML
    Html To Pdf    ${sales_results_html}    ${OUTPUT_DIR}${/}sales_results.pdf

Log out and close the browser
    Click Button    Log out
    Close Browser
