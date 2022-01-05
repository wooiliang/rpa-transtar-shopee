*** Settings ***
Documentation     Template robot main suite.
Library         RPA.Browser
Library         RPA.Browser.Selenium

*** Variables ***
#${SHOP_ID}    338236667
${SHOP_ID}    603028193
#${ITEM_ID}    6963039936
${ITEM_ID}    14224149873
#${ITEM_ID}    0
#${TITLE}    Eyeglasses-Retainers-Silicone-Glasses
${TITLE}    Transtar-VTL-Land-Bus-Service-(1-Feb)-Singapore-to-Malaysia
#${PRODUCT_VARIATION}    1 pair
${PRODUCT_VARIATION}    Adult

*** Keyword ***
Login
    RPA.Browser.Open Available Browser    https://shopee.sg/buyer/login
    RPA.Browser.Wait Until Element Is Visible    name:loginKey
    RPA.Browser.Input Text    name:loginKey    %{SHOPEE_USERNAME}
    RPA.Browser.Wait Until Element Is Visible    name:password
    RPA.Browser.Input Password    name:password    %{SHOPEE_PASSWORD}
    RPA.Browser.Press Keys    None    RETURN
    RPA.Browser.Wait Until Location Contains    verify
    RPA.Browser.Wait Until Page Contains Element    //button[div]
    RPA.Browser.Click Element If Visible    //button[div][1]

*** Keyword ***
Wait Item
    RPA.Browser.Go To    https://shopee.sg/shop/${SHOP_ID}/search
    FOR    ${i}    IN RANGE    9999999
        RPA.Browser.Wait Until Page Contains Element    //div[contains(@class, 'shop-search-result-view')]
        ${res}    RPA.Browser.Does Page Contain Element    //a[contains(@href,'${TITLE}')]
        Exit For Loop If    ${res} == True
        RPA.Browser.Reload Page
    END
    RPA.Browser.Click Element If Visible    //a[contains(@href,'${TITLE}')][1]

*** Keyword ***
Wait Open
    IF    ${ITEM_ID} != 0
        RPA.Browser.Go To    https://shopee.sg/product/${SHOP_ID}/${ITEM_ID}
    END
    FOR    ${i}    IN RANGE    9999999
        RPA.Browser.Wait Until Element Is Visible    //button[contains(@class, 'product-variation')]
        ${res}    RPA.Browser.Does Page Contain Element    //button[contains(@class, 'product-variation') and not(contains(@class, 'product-variation--disabled'))]
        Exit For Loop If    ${res} == True
        RPA.Browser.Reload Page
    END
    RPA.Browser.Wait Until Element Is Visible    //button[contains(@class, 'product-variation') and not(contains(@class, 'product-variation--disabled'))]
    RPA.Browser.Click Element If Visible    //button[contains(@class, 'product-variation') and not(contains(@class, 'product-variation--disabled'))][1]
    RPA.Browser.Wait Until Element Is Visible    //button[text()='${PRODUCT_VARIATION}']
    RPA.Browser.Click Element If Visible    //button[text()='${PRODUCT_VARIATION}'][1]
    RPA.Browser.Wait Until Element Is Visible    //button[text()='buy now']
    RPA.Browser.Click Element If Visible    //button[text()='buy now'][1]
    RPA.Browser.Wait Until Element Is Visible    //button[span[text()='check out']]
    RPA.Browser.Click Element If Visible    //button[span[text()='check out']][1]
    RPA.Browser.Wait Until Element Is Visible    //button[text()='PayNow']
    RPA.Browser.Click Element If Visible    //button[text()='PayNow'][1]
    RPA.Browser.Wait Until Element Is Visible    //button[text()='Place Order']
    RPA.Browser.Click Element If Visible    //button[text()='Place Order'][1]

*** Tasks ***
Minimal task
    #Login
    #Wait Until Location Is    https://shopee.sg/    300
    RPA.Browser.Attach Chrome Browser    9222
    IF    ${ITEM_ID} == 0
        Wait Item
    END
    Wait Open
    Log    Done.
