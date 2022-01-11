*** Settings ***
Documentation     Template robot main suite.
Library         RPA.Browser
Library         RPA.Browser.Selenium

*** Variables ***
${SHOP_ID}    603028193
${ITEM_ID}    0
${TITLE}    Transtar-VTL-Land-Bus-Service-(5-Feb)-Singapore-to-Malaysia
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
    RPA.Browser.Go To    https://shopee.sg/shop/${SHOP_ID}/search?page=0&sortBy=ctime
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

*** Keyword ***
Wait Checkout
    FOR    ${i}    IN RANGE    9999999
        RPA.Browser.Go To    https://shopee.sg/cart
        FOR    ${i}    IN RANGE    9999999
            RPA.Browser.Set Browser Implicit Wait    1.5
            ${res}    RPA.Browser.Does Page Contain Element    (//div[@role='main']/div)[2]//label[contains(@class,'stardust-checkbox') and not(contains(@class,'stardust-checkbox--disabled'))]
            Exit For Loop If    ${res} == True
            RPA.Browser.Reload Page
        END
        RPA.Browser.Wait Until Element Is Visible    ((//div[@role='main']/div)[2]//label[contains(@class,'stardust-checkbox') and not(contains(@class,'stardust-checkbox--disabled'))])[2]/div
        RPA.Browser.Click Element If Visible    ((//div[@role='main']/div)[2]//label[contains(@class,'stardust-checkbox') and not(contains(@class,'stardust-checkbox--disabled'))])[2]/div
        RPA.Browser.Wait Until Element Is Visible    //button[span[text()='check out']]
        RPA.Browser.Click Element If Visible    //button[span[text()='check out']][1]
        RPA.Browser.Wait Until Element Is Visible    //button[text()='PayNow']
        RPA.Browser.Click Element If Visible    //button[text()='PayNow'][1]
        RPA.Browser.Wait Until Element Is Visible    //button[text()='Place Order']
        RPA.Browser.Click Element If Visible    //button[text()='Place Order'][1]
        RPA.Browser.Set Browser Implicit Wait    5
    END

*** Tasks ***
Minimal task
    #Login
    #Wait Until Location Is    https://shopee.sg/    300

    RPA.Browser.Attach Chrome Browser    9222

    #IF    ${ITEM_ID} == 0
    #    Wait Until Keyword Succeeds    3x    0.5s    Wait Item
    #END
    #Wait Until Keyword Succeeds    3x    0.5s    Wait Open

    Wait Until Keyword Succeeds    3x    0.5s    Wait Checkout

    Log    Done.
