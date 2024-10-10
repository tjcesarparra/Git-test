<?xml version="1.0"?>
<!DOCTYPE pdf PUBLIC "-//big.faceless.org//report" "report-1.1.dtd">
<!--
Copyright (c) 2022 Trajectory Inc.
250 The Esplanade, Suite 402, Toronto, ON, Canada, M5A 1J2
www.trajectoryinc.com
All Rights Reserved.

System: CaseWare
Module: CAS
Version: 0.0.2b
Company: Trajectory Inc.
CreationDate: 20230425
FileName: CaseWare Invoice Template.ftl
-->
<pdf>
<#assign a_item = record.item/>
<#--  Macros Definition  -->
<#macro listGroups items groupField>
    <#if items?size == 0><#return></#if>
    <#local sortedItems = items?sort_by(groupField)>
    <#local groupStart = 0>
    <#list sortedItems as item>
        <#if !item?is_first && item[groupField] != lastItem[groupField]>
            <#local groupEnd = item?index>
            <#nested lastItem[groupField], sortedItems[groupStart ..< groupEnd]>
            <#local groupStart = groupEnd>
        </#if>
        <#local lastItem = item>
    </#list>
    <#local groupEnd = sortedItems?size>
    <#nested lastItem[groupField], sortedItems[groupStart ..< groupEnd]>
</#macro>

<#macro listGroupsOfSorted items groupFields...>
  <#if items?size == 0><#return></#if>
  <#local groupStart = 0>
  <#list items as item>
    <#if !item?is_first && !subvariablesEqual(item, lastItem, groupFields)>
      <#local groupEnd = item?index>
      <#nested items[groupStart ..< groupEnd]>
      <#local groupStart = groupEnd>
    </#if>
    <#local lastItem = item>
  </#list>
  <#local groupEnd = items?size>
  <#nested items[groupStart ..< groupEnd]>
</#macro>

<#function subvariablesEqual(obj1, obj2, subVars)>
  <#list subVars as subVar>
    <#if obj1[subVar] != obj2[subVar]>
      <#return false>
    </#if>
  </#list>
  <#return true>
</#function>

<#--  functon Definition  -->
<#function extractFirstCharacter text>
    <#assign a_subsidiaries = ['23']>
    <#if (a_subsidiaries?seq_contains(record.subsidiary.id))>
        <#return text?substring(0,2)>
    <#else>
        <#return text?substring(0,1)>
    </#if>
</#function>

<#assign a_subsidiariesLayout = ['41']/>
<#assign total = record.total>
<#assign currency_symbol = extractFirstCharacter(total)>

<#setting number_format=",##0.00">

<#assign handle = nstranslation.load({
    "collections":[{
        "alias": "casewaretranslation",
        "collection": "custcollection_cw_translation",
        "keys": ["PHONE", "INVTERMS5LATAMGOV","INVTERMS7LATAMGOV","ATTENTION","CUSTOMERNUMBER","PRODUCTNAME","TOTAL","PAYMENTTERMS","BILLTO","SHIPTO","SHIPPINGINFORMATION","PRICEPERUNIT","INVOICE","INVOICENUMBER","UNIT","TERMSDETAILS1","TERM","TERMS","INVTERMS1","INVTERMS2","INVTERMS3","INVTERMS4","INVTERMS5","INVTERMS6","INVTERMS7","INVTERMS8","TAXNUMBER","COMPANYREGNO","VENDORTAXID","VATNUMBER","DUEUPONRECEIPT","PAYBYWIRE","PAYBYBANKTRANSFER","BILLINGINQUIRIES","PAYMENTMETHODS","CCSURCHARGE","PAYBYCHEQUE","QUANTITY","CUSTOMERVAT","VAT","MONTHS","NET10","NET120","NET15","NET30","NET45","NET60","NET90","NOTES","CLOUDFIRMNAME"]}]
    })>

    <head>
        <link name="NotoSans" type="font" subtype="truetype" src="${nsfont.NotoSans_Regular}"
            src-bold="${nsfont.NotoSans_Bold}" src-italic="${nsfont.NotoSans_Italic}"
            src-bolditalic="${nsfont.NotoSans_BoldItalic}" bytes="2" />
        <#if .locale=="zh_CN">
            <link name="NotoSansCJKsc" type="font" subtype="opentype" src="${nsfont.NotoSansCJKsc_Regular}"
                src-bold="${nsfont.NotoSansCJKsc_Bold}" bytes="2" />
            <#elseif .locale=="zh_TW">
                <link name="NotoSansCJKtc" type="font" subtype="opentype" src="${nsfont.NotoSansCJKtc_Regular}"
                    src-bold="${nsfont.NotoSansCJKtc_Bold}" bytes="2" />
                <#elseif .locale=="ja_JP">
                    <link name="NotoSansCJKjp" type="font" subtype="opentype" src="${nsfont.NotoSansCJKjp_Regular}"
                        src-bold="${nsfont.NotoSansCJKjp_Bold}" bytes="2" />
                    <#elseif .locale=="ko_KR">
                        <link name="NotoSansCJKkr" type="font" subtype="opentype" src="${nsfont.NotoSansCJKkr_Regular}"
                            src-bold="${nsfont.NotoSansCJKkr_Bold}" bytes="2" />
                        <#elseif .locale=="th_TH">
                            <link name="NotoSansThai" type="font" subtype="opentype"
                                src="${nsfont.NotoSansThai_Regular}" src-bold="${nsfont.NotoSansThai_Bold}" bytes="2" />
        </#if>
        <macrolist>
            <macro id="nlheader">
                <table class="header" style="width: 100%;">
                    <tr>
                        <td align="left">${subsidiary.logo}</td>
                      
                   <#if record.subsidiary="AU01 CW Australia Pty Ltd.">
                      
                          <td align="right"><span style="text-transform: uppercase"><span
                                    class="title">TAX INVOICE</span></span></td>
                         
                      <#else>
                        <td align="right"><span style="text-transform: uppercase"><span
                                    class="title">${handle.casewaretranslation.INVOICE}</span></span></td>
                        </#if>

                        
                        
                    </tr>
                    <tr></tr>
                    <tr></tr>
                </table>
            </macro>
            <macro id="nlfooter">
                <table class="footer" style="width: 100%;">
                    <tr>
                        <td align="right">
                            <pagenumber /> of
                            <totalpages />
                        </td>
                    </tr>
                </table>
            </macro>
        </macrolist>
        <style type="text/css">
            * {
                <#if .locale=="zh_CN">font-family: NotoSans, NotoSansCJKsc, sans-serif;
                <#elseif .locale=="zh_TW">font-family: NotoSans, NotoSansCJKtc, sans-serif;
                <#elseif .locale=="ja_JP">font-family: NotoSans, NotoSansCJKjp, sans-serif;
                <#elseif .locale=="ko_KR">font-family: NotoSans, NotoSansCJKkr, sans-serif;
                <#elseif .locale=="th_TH">font-family: NotoSans, NotoSansThai, sans-serif;
                <#else>font-family: NotoSans, sans-serif;
                </#if>
            }

            table {
                font-size: 9pt;
                table-layout: fixed;
            }

            th {
                font-weight: bold;
                font-size: 10pt;
                vertical-align: middle;
                padding: 5px 6px 3px;
                background-color: #FFFFFF;
                color: #333333;
            }

            td {
                padding: 4px 6px;
                font-size: 10pt;
            }

            td p {
                align: left
            }

            b {
                font-weight: bold;
                color: #333333;
            }

            table.header td {
                padding: 0px;
                font-size: 10pt;
            }

            table.footer td {
                padding: 0px;
                font-size: 7.5pt;
            }

            table.itemtable th {
                padding-bottom: 8px;
                padding-top: 8px;
            }

            table.body td {
                padding-top: 2px;
            }

            table.total {
                page-break-inside: avoid;
            }

            tr.totalrow {
                background-color: #FFFFFF;
                line-height: 200%;
            }

            td.addressheader {
                font-size: 10pt;
                padding-top: 2px;
                padding-bottom: 2px;

            }

            span.title {
                font-size: 14pt;
                font-weight: bold;
            }

            span.itemname {
                font-weight: normal;
                line-height: 125%;
            }

            span.terms {
                font-size: 10;
                text-align: left;

            line-height: 125%;

            }

            span.paymentterms {
                font-weight: bold;
                font-size: 10pt;
            padding-top: 2px;
            padding-bottom: 2px;
            }

            hr {
                width: 100%;
                color: #000000;
                background-color: #000000;
                height: 2px;
            }

            .bundle_title {
                background-color: #bbbbbb;
            }
        </style>
    </head>

    <body header="nlheader" header-height="10%" footer="nlfooter" footer-height="20pt" padding="0.5in 0.5in 0.5in 0.5in"
        size="Letter">
        <table style="width: 100%; margin-top: 10px;">
            <tr>
            <td align="center" class="addressheader" colspan="3"><b>${subsidiary.legalname}</b></td>
            </tr>
          <#if record.subsidiary="EU04 StriveCo GmbH">
            <tr>
                <td align="center" class="addressheader" colspan="3"><b>${subsidiary.addr1},
                        ${subsidiary.city} ${subsidiary.state} ${subsidiary.zip}</b></td>
            </tr>
            <#else>
              <tr>
                <td align="center" class="addressheader" colspan="3"><b>${subsidiary.addr1} ${subsidiary.addr2}
                        ${subsidiary.city} ${subsidiary.state} ${subsidiary.zip} ${subsidiary.country}</b></td>
            </tr>
              </#if>
       <#if record.subsidiary="DK01 CW Denmark ApS">
          <tr>
                <td align="center" class="addressheader" colspan="3"><b> ${handle.casewaretranslation.PHONE}: +${subsidiary.addrphone}</b></td>
            </tr>
<#elseif record.subsidiary="SG01 CW Asia Pte">
  <tr> <td align="center" class="addressheader" colspan="3"><b> ${handle.casewaretranslation.PHONE}: +${subsidiary.addrphone}</b></td></tr>


         
          <#else>          
            <tr>
                <td align="center" class="addressheader" colspan="3"><b> ${handle.casewaretranslation.PHONE}: ${subsidiary.addrphone}</b></td>
            </tr>
            </#if>
            <tr></tr>
        </table>

        <hr />
        <table class="body" style="width: 100%; margin-top: 10px;">
        <#if record.subsidiary="EU02 CW NL B.V.">
          <tr>
                <td colspan="20"><b>${record.trandate@label}: </b>${record.trandate?string('dd.MM.yyyy')}</td>
               <td colspan="16"><b>${record.tranid@label}: </b> ${record.tranid}</td></tr>
                <#elseif record.subsidiary="EU03 CW C2C B.V.">
          <tr><td colspan="20"><b>${record.trandate@label}: </b>${record.trandate?string('dd.MM.yyyy')}</td>
               <td colspan="16"><b>${record.tranid@label}: </b> ${record.tranid}</td></tr>
          <#elseif record.subsidiary="EU04 StriveCo GmbH">
          <tr><td colspan="20"><b>${record.trandate@label}: </b>${record.trandate?string('dd.MM.yyyy')}</td>
               <td colspan="16"><b>${handle.casewaretranslation.INVOICENUMBER}: </b> ${record.tranid}</td></tr>
             <#elseif record.subsidiary="DK01 CW Denmark ApS">
          <tr><td colspan="20"><b>${record.trandate@label}: </b>${record.trandate?string('dd.MM.yyyy')}</td>
               <td colspan="16"><b>${record.tranid@label}: </b> ${record.tranid}</td></tr>     
                  <#else>
                 <tr>
                 <td colspan="20"><b>${record.trandate@label}: </b>${record.trandate}</td>
                <td colspan="16"><b>${record.tranid@label}: </b> ${record.tranid}</td>
            </tr>
      </#if>    
            <tr>
                <td><br /></td>
            </tr>

<#if record.custbody_cw_thirdpartybilling==true>
              <#if record.subsidiary.custrecord_cw_showthirdpartyname==true>
                <#if record.subsidiary.custrecord_cw_showcustomername==false>
                 <#if record.subsidiary="CA04 CWI" && record.shipcountry="CA">     
                <tr>
                    <td colspan="20"><b>${record.custbody_thirdpartyname} </b></td>
                  <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.federalidnumber}</td>
                    </tr>
                 <#elseif record.subsidiary="CA04 CWI" && record.shipcountry="US">
        <tr>
                    <td colspan="20"><b>${record.custbody_thirdpartyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.custrecord_cw_taxid2}</td>
                </tr>
                <#elseif record.subsidiary="CA06 CW Cloud" && record.shipcountry="CA">
             <tr>
                    <td colspan="20"><b>${record.custbody_thirdpartyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.federalidnumber}</td>
                </tr>
           <#elseif record.subsidiary="CA06 CW Cloud" && record.shipcountry="US">
              <tr>
                    <td colspan="20"><b>${record.custbody_thirdpartyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.custrecord_cw_taxid2}</td>
                </tr>
          <#elseif record.subsidiary="DK01 CW Denmark ApS">
               <tr>
                    <td colspan="20"><b>${record.custbody_thirdpartyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.VATNUMBER}: </b>${subsidiary.federalidnumber}</td>
                </tr>
          <#elseif record.subsidiary="GB02 CW UK">
                    <tr>
                    <td colspan="20"><b>${record.custbody_thirdpartyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.COMPANYREGNO}: </b>${subsidiary.custrecord_cw_taxid2}</td>
                </tr>
       <#elseif record.subsidiary="AU01 CW Australia Pty Ltd.">
                          <tr>
                    <td colspan="20"><b>${record.custbody_thirdpartyname} </b></td>
                    <td colspan="16"><b>ABN: </b>${subsidiary.federalidnumber}</td>
                </tr>       
              <#else>
                <tr>
                    <td colspan="20"><b>${record.custbody_thirdpartyname} </b></td>
                  <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.federalidnumber}</td>
                </tr>
                </#if>


                
              <#else>
                       <#if record.subsidiary="CA04 CWI" && record.shipcountry="CA">     
                   <tr>
                    <td colspan="20"><b>${record.entity.companyname} c/o ${record.custbody_thirdpartyname}</b></td>
                  <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.federalidnumber}</td>
                    </tr>
                 <#elseif record.subsidiary="CA04 CWI" && record.shipcountry="US">
        <tr>
                    <td colspan="20"><b>${record.entity.companyname} c/o ${record.custbody_thirdpartyname}</b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.custrecord_cw_taxid2}</td>
                </tr>
                <#elseif record.subsidiary="CA06 CW Cloud" && record.shipcountry="CA">
             <tr>
                    <td colspan="20"><b>${record.entity.companyname} c/o ${record.custbody_thirdpartyname}</b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.federalidnumber}</td>
                </tr>
           <#elseif record.subsidiary="CA06 CW Cloud" && record.shipcountry="US">
              <tr>
                    <td colspan="20"><b>${record.entity.companyname} c/o ${record.custbody_thirdpartyname}</b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.custrecord_cw_taxid2}</td>
                </tr>
          <#elseif record.subsidiary="DK01 CW Denmark ApS">
               <tr>
                    <td colspan="20"><b>${record.entity.companyname} c/o ${record.custbody_thirdpartyname}</b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.VATNUMBER}: </b>${subsidiary.federalidnumber}</td>
                </tr>
          <#elseif record.subsidiary="GB02 CW UK">
                    <tr>
                    <td colspan="20"><b>${record.entity.companyname} c/o ${record.custbody_thirdpartyname}</b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.COMPANYREGNO}: </b>${subsidiary.custrecord_cw_taxid2}</td>
                </tr>
       <#elseif record.subsidiary="AU01 CW Australia Pty Ltd.">
                          <tr>
                    <td colspan="20"><b>${record.entity.companyname} c/o ${record.custbody_thirdpartyname}</b></td>
                    <td colspan="16"><b>ABN: </b>${subsidiary.federalidnumber}</td>
                </tr>

                <#else>
                <tr>
                    <td colspan="20"><b>${record.entity.companyname} c/o ${record.custbody_thirdpartyname}</b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.federalidnumber}</td>
                    </tr>
                  </#if>
                  </#if>
                
 <#else>
<#if record.subsidiary="CA04 CWI" && record.shipcountry="CA"> 
                 <tr>
                    <td colspan="20"><b>${record.entity.companyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.federalidnumber}</td>
                </tr>
      <#elseif record.subsidiary="CA04 CWI" && record.shipcountry="US">
        <tr>
                    <td colspan="20"><b>${record.entity.companyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.custrecord_cw_taxid2}</td>
                </tr>
         <#elseif record.subsidiary="CA06 CW Cloud" && record.shipcountry="CA">
             <tr>
                    <td colspan="20"><b>${record.entity.companyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.federalidnumber}</td>
                </tr>
           <#elseif record.subsidiary="CA06 CW Cloud" && record.shipcountry="US">
              <tr>
                    <td colspan="20"><b>${record.entity.companyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.custrecord_cw_taxid2}</td>
                </tr>
          <#elseif record.subsidiary="DK01 CW Denmark ApS">
               <tr>
                    <td colspan="20"><b>${record.entity.companyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.VATNUMBER}: </b>${subsidiary.federalidnumber}</td>
                </tr>
          <#elseif record.subsidiary="GB02 CW UK">
                    <tr>
                    <td colspan="20"><b>${record.entity.companyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.COMPANYREGNO}: </b>${subsidiary.custrecord_cw_taxid2}</td>
                </tr>
       <#elseif record.subsidiary="AU01 CW Australia Pty Ltd.">
                          <tr>
                    <td colspan="20"><b>${record.entity.companyname} </b></td>
                    <td colspan="16"><b>ABN: </b>${subsidiary.federalidnumber}</td>
                </tr>      
        <#else>        
      <tr>
                    <td colspan="20"><b>${record.entity.companyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.federalidnumber}</td>
                </tr>   
        </#if>        
       </#if>      
<#else>
        <#if record.subsidiary="CA04 CWI" && record.shipcountry="CA"> 
                 <tr>
                    <td colspan="20"><b>${record.entity.companyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.federalidnumber}</td>
                </tr>
      <#elseif record.subsidiary="CA04 CWI" && record.shipcountry="US">
        <tr>
                    <td colspan="20"><b>${record.entity.companyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.custrecord_cw_taxid2}</td>
                </tr>
         <#elseif record.subsidiary="CA06 CW Cloud" && record.shipcountry="CA">
             <tr>
                    <td colspan="20"><b>${record.entity.companyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.federalidnumber}</td>
                </tr>
           <#elseif record.subsidiary="CA06 CW Cloud" && record.shipcountry="US">
              <tr>
                    <td colspan="20"><b>${record.entity.companyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.custrecord_cw_taxid2}</td>
                </tr>
          <#elseif record.subsidiary="DK01 CW Denmark ApS">
               <tr>
                    <td colspan="20"><b>${record.entity.companyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.VATNUMBER}: </b>${subsidiary.federalidnumber}</td>
                </tr>
          <#elseif record.subsidiary="GB02 CW UK">
                    <tr>
                    <td colspan="20"><b>${record.entity.companyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.COMPANYREGNO}: </b>${subsidiary.custrecord_cw_taxid2}</td>
                </tr>
       <#elseif record.subsidiary="AU01 CW Australia Pty Ltd.">
                          <tr>
                    <td colspan="20"><b>${record.entity.companyname} </b></td>
                    <td colspan="16"><b>ABN: </b>${subsidiary.federalidnumber}</td>
                </tr>      
        <#else>        
      <tr>
                    <td colspan="20"><b>${record.entity.companyname} </b></td>
                    <td colspan="16"><b>${handle.casewaretranslation.TAXNUMBER}: </b>${subsidiary.federalidnumber}</td>
                </tr>   
        </#if>        
</#if>


          
<#if record.subsidiary="GB02 CW UK">
                    <tr>
                        <td colspan="20">${handle.casewaretranslation.ATTENTION}: ${record.custbody_cw_primarycontactname}</td>
                    <td colspan="16"><b>VAT No: </b>${subsidiary.federalidnumber}</td>
                    </tr>
<#else>
    <tr>
                        <td colspan="20">${handle.casewaretranslation.ATTENTION}: ${record.custbody_cw_primarycontactname}</td>
                    </tr>
</#if>
                <#if record.otherrefnum?has_content>
                <tr>
                    <td colspan="20">${record.entity.email@label}: ${record.custbody_cw_primarycontactemail}</td>
                    <td colspan="16"><b>PO#: </b>${record.otherrefnum}</td>
                </tr>
                <#else>
                    <tr>
                        <td colspan="20">${record.entity.email@label}: ${record.custbody_cw_primarycontactemail}</td>
                    </tr>
            </#if>
            <tr>
                <td colspan="20">${handle.casewaretranslation.PHONE}: ${record.custbody_cw_primarycontactphone}</td>
            </tr>


                  
 <#if record.custbody_cw_thirdpartybilling==true>
        <#if record.subsidiary.custrecord_cw_showthirdpartyname==true>
              <#if record.subsidiary.custrecord_cw_showcustomername==false>
                       <#if record.custbody_thirdpartytaxid?has_content>
                                               <#if record.subsidiary=="EU04 StriveCo GmbH" && record.shipcountry="DE">
                                                 <#else>
                       <tr>
                       <td colspan="20">Third Party VAT No: ${record.custbody_thirdpartytaxid}</td>
                       </tr>
                                                   </#if>
                       </#if>
              <#else>
                      <#if record.entity.vatregnumber?has_content>
                            <#if record.custbody_thirdpartytaxid?has_content>
                              <#if record.subsidiary=="EU04 StriveCo GmbH" && record.shipcountry="DE">
                                                 <#else>
                              <tr><td colspan="20">${handle.casewaretranslation.CUSTOMERVAT}: ${record.entity.vatregnumber}</td></tr>
                              <tr><td colspan="20">Third Party VAT No: ${record.custbody_thirdpartytaxid}</td></tr>
                                                   </#if>
                              <#if record.entity.custentity_cw_siren?has_content>
                   <#if record.subsidiary=="EU04 StriveCo GmbH" && record.shipcountry="DE">
                   <#else>
                   <tr>
                   <td colspan="20">SIREN: ${record.entity.custentity_cw_siren}</td>
                   </tr>
                   </#if>
                </#if>
                            <#else>
                              <#if record.subsidiary=="EU04 StriveCo GmbH" && record.shipcountry="DE">
                                                 <#else>
                              <tr><td colspan="20">${handle.casewaretranslation.CUSTOMERVAT}: ${record.entity.vatregnumber}</td></tr>
                                                   </#if>
                              <#if record.entity.custentity_cw_siren?has_content>
                   <#if record.subsidiary=="EU04 StriveCo GmbH" && record.shipcountry="DE">
                   <#else>
                   <tr>
                   <td colspan="20">SIREN: ${record.entity.custentity_cw_siren}</td>
                   </tr>
                   </#if>
                </#if>
                            </#if>
                      <#else>
                             <#if record.custbody_thirdpartytaxid?has_content>
                               <#if record.subsidiary=="EU04 StriveCo GmbH" && record.shipcountry="DE">
                                                 <#else>
                             <tr>
                             <td colspan="20">Third Party VAT No: ${record.custbody_thirdpartytaxid}</td>
                             </tr>
                                                   </#if>
                             </#if>
                      </#if>
              </#if>
        <#else>
               <#if record.entity.vatregnumber?has_content>
                 <#if record.subsidiary=="EU04 StriveCo GmbH" && record.shipcountry="DE">
                                                 <#else>
               <tr><td colspan="20">Customer VAT No: ${record.entity.vatregnumber}</td></tr>
                                                   </#if>
                 <#if record.entity.custentity_cw_siren?has_content>
                   <#if record.subsidiary=="EU04 StriveCo GmbH" && record.shipcountry="DE">
                   <#else>
                   <tr>
                   <td colspan="20">SIREN: ${record.entity.custentity_cw_siren}</td>
                   </tr>
                   </#if>
                </#if>
               </#if>
        </#if>
<#else>
  <#if record.entity.vatregnumber?has_content>
                   <#if record.subsidiary="GB02 CW UK">
                   <tr>
                   <td colspan="20">Customer VAT No: ${record.entity.vatregnumber}</td>
                   </tr>
                   <#elseif record.subsidiary="DK01 CW Denmark ApS">
                   <tr>
                   <td colspan="20">${handle.casewaretranslation.CUSTOMERVAT}: ${record.entity.vatregnumber}</td>
                   </tr>
                   <#elseif record.subsidiary="AU01 CW Australia Pty Ltd.">
                   <tr>
                   <td colspan="20">Customer ABN: ${record.entity.vatregnumber}</td>
                   </tr>  
                   <#elseif record.subsidiary=="EU04 StriveCo GmbH" && record.shipcountry="DE">  
                   <#else>
                    <tr>
                    <td colspan="20">${handle.casewaretranslation.CUSTOMERVAT}: ${record.entity.vatregnumber}</td>
                    </tr>
                    </#if>
          </#if>
<#if record.entity.custentity_cw_siren?has_content>
                   <#if record.subsidiary=="EU04 StriveCo GmbH" && record.shipcountry="DE">
                   <#else>
                   <tr>
                   <td colspan="20">SIREN: ${record.entity.custentity_cw_siren}</td>
                   </tr>
                   </#if>
                </#if>
</#if>
                 
            
        </table>

        <hr />
        <table class="body" style="width: 100%; margin-top: 10px;">
 <#if record.custbody_cw_thirdpartybilling==false>
            <#if record.custbody_cw_cloudfirmname?has_content>
          <tr>
                <td colspan="20"><b>${handle.casewaretranslation.CUSTOMERNUMBER}:</b> ${record.entity.entityid} </td>
            <td colspan="16"><b>${handle.casewaretranslation.CLOUDFIRMNAME}:</b> ${record.custbody_cw_cloudfirmname} </td>
            </tr>
            <tr>
                <td><br /></td>
            </tr>
              <#else>
                          <tr>
                <td colspan="20"><b>${handle.casewaretranslation.CUSTOMERNUMBER}:</b> ${record.entity.entityid} </td>
            </tr>
            <tr>
                <td><br /></td>
            </tr>
                </#if>
                <#else>
                  <#if record.custbody_cw_cloudfirmname?has_content>
                   <#if record.subsidiary.custrecord_cw_showthirdpartyname==true>
                     <#if record.subsidiary.custrecord_cw_showcustomername==true>
                       <tr>
                       <td colspan="20"><b>${handle.casewaretranslation.CUSTOMERNUMBER}:</b> ${record.entity.entityid} </td>
            <td colspan="20"><b>${handle.casewaretranslation.CLOUDFIRMNAME}:</b> ${record.custbody_cw_cloudfirmname} </td>
            </tr>
            <tr>
                <td><br /></td>
            </tr> 
<#else>
                       
                  <tr>
                    
            <td colspan="20"><b>${handle.casewaretranslation.CLOUDFIRMNAME}:</b> ${record.custbody_cw_cloudfirmname} </td>
            </tr>
            <tr>
                <td><br /></td>
            </tr>
  </#if>
                     <#else>
                       
                     <tr>
                       <td colspan="20"><b>${handle.casewaretranslation.CUSTOMERNUMBER}:</b> ${record.entity.entityid} </td>
            <td colspan="20"><b>${handle.casewaretranslation.CLOUDFIRMNAME}:</b> ${record.custbody_cw_cloudfirmname} </td>
            </tr>
            <tr>
                <td><br /></td>
            </tr> 
                         
                       </#if>
            </#if>
            </#if>
            <tr>
                <td colspan="20"><b>${handle.casewaretranslation.SHIPPINGINFORMATION}</b></td>
            </tr>
            <tr>
                <td colspan="20">${handle.casewaretranslation.SHIPTO}:</td>
                <td colspan="16">${handle.casewaretranslation.BILLTO}:</td>
            </tr>
            <tr>
                <td colspan="20">${record.shipaddr1}, ${record.shipaddr2}</td>
                <td colspan="16">${record.billaddr1}, ${record.billaddr2}</td>
            </tr>
            <tr>
                <td colspan="20">${record.shipcity}, ${record.shipstate} ${record.shipzip}</td>
                <td colspan="16">${record.billcity}, ${record.billstate} ${record.billzip}</td>
            </tr>
            <tr>
                <td colspan="20">${record.shipcountry}</td>
                <td colspan="16">${record.billcountry}</td>
            </tr>
        </table>
        <#if record.item?has_content>
            <#setting locale="en_US">
            <table class="itemtable" style="width: 100%; margin-top: 10px;"><!-- start items -->

                <#list record.item as item>
                    <#if item_index==0>
                        <#if (!a_subsidiariesLayout?seq_contains(record.subsidiary.id))>
                            <thead>
                                <tr>
                                    <th colspan="18">${handle.casewaretranslation.PRODUCTNAME}</th>
                                    <th align="center" colspan="6">${handle.casewaretranslation.QUANTITY}</th>
                                    <th align="center" colspan="6">${handle.casewaretranslation.UNIT}</th>
                                    <th align="right" colspan="6">${handle.casewaretranslation.PRICEPERUNIT}</th>
                                    <th align="right" colspan="6">${item.amount@label}</th>
                                </tr>
                            </thead>
                        <#else>
                            <thead>
                                <tr>
                                    <th colspan="18">${handle.casewaretranslation.PRODUCTNAME}</th>
                                    <th align="center" colspan="6"></th>
                                    <th align="center" colspan="6"></th>
                                    <th align="right" colspan="6"></th>
                                    <th align="right" colspan="6">${handle.casewaretranslation.QUANTITY}</th>
                                </tr>
                            </thead>
                        </#if>
                    </#if>
                </#list><!-- end items  -->
                <#--  Sort by  StartDate, EndDate and BundleName When the "Bundle Hide?" column is false -->
                <#assign item_bundle = []>
                <#assign uncheckedBundle = []>
                <#list record.item as element>
                    <#if !element.custcol_cw_hidebundle>
                        <#assign elementTemp = element + { "key_group": "${element.custcol_cw_bundlename}_${element.custcolcw_bundlesku}_${element.custcolcw_contractstart}_${element.custcolcw_contractend}"}>
                        <#assign uncheckedBundle = uncheckedBundle + [elementTemp]>
                    </#if>
                </#list>
                <@listGroups uncheckedBundle?sort_by("custcolcw_contractstart")?sort_by("custcolcw_contractend") "key_group" ; groupName, groupItems> <!--Put bundle separator line-->
                    <#assign bundle_total = 0>
                    <#assign hide_count_total = 0>
                    <#assign bundleName = "">
                    <#list groupItems as groupItem>
                        <#assign item_bundle = {
                            "bundleName": groupItem.custcol_cw_bundlename,
                            "quantity": groupItem.custcol_cw_bundlequantity,
                            "price": groupItem.custcol_cw_bundleunitprice,
                            "hide_bundle": groupItem.custcol_cw_hidebundle,
                            "startdate": groupItem.custcolcw_contractstart,
                            "enddate": groupItem.custcolcw_contractend
                        }>
                        <#if (!groupItem.custcol_cw_hidebundle)>
                            <#assign bundle_total = bundle_total + groupItem.amount>
                        <#elseif (groupItem.custcol_cw_hidebundle)>
                            <#assign hide_count_total = hide_count_total + 1>
                        </#if>
                        <#assign bundleName = groupItem.custcol_cw_bundlename>
                    </#list>
                        <#if (bundleName?length > 0 && hide_count_total != groupItems?size)>
                            <#if (!a_subsidiariesLayout?seq_contains(record.subsidiary.id))>
                                <tr class="bundle_title">
                                    <td colspan="18"><b>${item_bundle.bundleName}</b></td>
                                    <td align="center" colspan="6" line-height="150%">
                                        <b>
                                            <#if (item_bundle.quantity != 0)>
                                                ${item_bundle.quantity?string.number}
                                            </#if>
                                        </b>
                                    </td>
                                    <td align="center" colspan="6"></td>
                                    <td align="right" colspan="6"><b>${currency_symbol}${item_bundle.price?string["#,##0.00"]}</b></td>
                                    <td align="right" colspan="6"><b>${currency_symbol}${bundle_total?string["#,##0.00"]}</b></td>
                            <#else>
                                <tr class="bundle_title">
                                    <td colspan="18"><b>${item_bundle.bundleName}</b></td>
                                    <td align="center" colspan="6" line-height="150%"></td>
                                    <td align="center" colspan="6"></td>
                                    <td align="right" colspan="6"></td>
                                    <td align="right" colspan="6">
                                        <b>
                                            <#if (item_bundle.quantity != 0)>
                                                ${item_bundle.quantity?string.number}
                                            </#if>
                                        </b>
                                    </td>
                            </#if>
                        <#else>
                            <tr>
                                <td colspan="18"></td>
                                <td align="center" colspan="6" line-height="150%"></td>
                                <td align="center" colspan="6"></td>
                                <td align="right" colspan="6"></td>
                                <td align="right" colspan="6"></td>
                        </#if>
                    </tr>

                    <#list groupItems as groupItem>
                        <#if groupItem.custcolcw_contractstart?has_content &&  groupItem.custcolcw_contractend?has_content>
                            <#assign startDate = groupItem.custcolcw_contractstart?long>
                            <#assign endDate = groupItem.custcolcw_contractend?long>
                            <#assign avgMonths = 30.4167>
                            <#assign daysBetween = (endDate - startDate) / (24 * 60 * 60 * 1000)>
                            <#assign totalMonths = daysBetween /  avgMonths>
                        </#if>
                        <#if (bundleName?length > 0 && !groupItem.custcol_cw_hidebundle)>
                            <#if (!a_subsidiariesLayout?seq_contains(record.subsidiary.id))>
                                <tr>
                                    <td colspan="18"><span class="itemname">${groupItem.custcol_cw_linedisplayname}</span></td>
                                    <td align="center" colspan="6" line-height="150%">${groupItem.quantity?string.number}</td>
                                    <td align="center" colspan="6">${groupItem.units}</td>
                                    <td align="right" colspan="6"></td>
                                    <td align="right" colspan="6"></td>
                                </tr>
                            <#else>
                                <tr>
                                    <td colspan="18"><span class="itemname">${groupItem.custcol_cw_linedisplayname}</span></td>
                                    <td align="center" colspan="6"></td>
                                    <td align="right" colspan="6"></td>
                                    <td align="right" colspan="6"></td>
                                    <td align="right" colspan="6" line-height="150%">${groupItem.quantity?string.number}</td>
                                </tr>
                            </#if>
                        </#if>
                    </#list>
                    <#if (bundleName?length > 0 && !item_bundle.hide_bundle)>
                        <tr>
                            <td colspan="24"> <#if item_bundle.startdate?has_content &&  item_bundle.enddate?has_content>
                            <span class="itemname">${handle.casewaretranslation.TERM}: ${totalMonths?round?string.number} ${handle.casewaretranslation.MONTHS}: </span> ${item_bundle.startdate} to ${item_bundle.enddate} </#if></td>
                            <td align="center" colspan="4" line-height="150%"></td>
                            <td align="right" colspan="4"></td>
                            <td align="right" colspan="4"></td>
                        </tr>
                    </#if>
                    <#if (bundleName?length > 0 && hide_count_total != groupItems?size)>
                        <tr style="border-top: 1px solid black; height:8px;"></tr>
                    </#if>
                </@listGroups>
                <#--  without bundle  -->
                <#--  When the "Bundle Hide?" column is true -->
                <#assign item_bundle = []>
                <#assign checkedBundle = []>
                <#list record.item as element>
                    <#if element.custcol_cw_hidebundle>
                        <#assign elementTemp = element + { "key_group": "${element.custcol_cw_bundlename}_${element.custcolcw_bundlesku}_${element.custcolcw_contractstart}_${element.custcolcw_contractend}_${element.custcol_cw_bundlequantity}"}>
                        <#assign checkedBundle = checkedBundle + [elementTemp]>
                    </#if>
                </#list>
                <@listGroups checkedBundle?sort_by("custcolcw_contractstart")?sort_by("custcolcw_contractend") "key_group" ; groupName, groupItems>
                    <#assign startDate = groupItems[0].custcolcw_contractstart?long>
                    <#assign endDate = groupItems[0].custcolcw_contractend?long>
                            <#assign avgMonths = 30.4167>
                            <#assign daysBetween = (endDate - startDate) / (24 * 60 * 60 * 1000)>
                            <#assign totalMonths = daysBetween /  avgMonths>
                            <#assign bundleName = groupItems[0].custcol_cw_bundlename>
                                    <#assign item_bundle = item_bundle + [{
                                    "bundleName": bundleName,
                                    "quantity": groupItems[0].custcol_cw_bundlequantity,
                                    "price": groupItems[0].custcol_cw_bundleunitprice?abs,
                                    "startdate": groupItems[0].custcolcw_contractstart?string,
                                    "enddate": groupItems[0].custcolcw_contractend?string,
                                    "amount": groupItems[0].custcol_cw_bundlequantity * groupItems[0].custcol_cw_bundleunitprice?abs,
                                    "totalMonths": totalMonths!0
                                        }]>
                            <tr>
                            <#if (bundleName?length == 0)>
                                    <#if (!a_subsidiariesLayout?seq_contains(record.subsidiary.id))>
                                <td colspan="18"><span class="itemname">${groupItems[0].custcol_cw_linedisplayname}</span></td>
                                <td align="center" colspan="6" line-height="150%">${groupItems[0].quantity?string.number}</td>
                                <td align="center" colspan="6">${groupItems[0].units}</td>
                                <td align="right" colspan="6">${currency_symbol}${groupItems[0].rate?string["#,##0.00"]}</td>
                                <td align="right" colspan="6">${currency_symbol}${groupItems[0].amount?string["#,##0.00"]}</td>
                                    <#else>
                                <td colspan="18"><span class="itemname">${groupItems[0].custcol_cw_linedisplayname}</span></td>
                                        <td align="center" colspan="6"></td>
                                        <td align="right" colspan="6"></td>
                                        <td align="right" colspan="6"></td>
                                <td align="right" colspan="6" line-height="150%">${groupItems[0].quantity?string.number}</td>
                                    </#if>
                                </#if>
                            </tr>
                            <tr>
                        <#if (bundleName?length == 0)>
                                    <td colspan="24">
                                <#if (groupItems[0].custcolcw_contractstart?has_content &&  groupItems[0].custcolcw_contractend?has_content) && groupItems[0].custcol_tjinc_hide_license_term == 'F'>
                                    <span class="itemname">${handle.casewaretranslation.TERM}: ${totalMonths?round?string.number} ${handle.casewaretranslation.MONTHS}: </span> ${groupItems[0].custcolcw_contractstart} to ${groupItems[0].custcolcw_contractend}
                                        </#if>
                                    </td>
                                    <td align="right" colspan="4"></td>
                                    <td align="right" colspan="4"></td>
                                    <td align="right" colspan="4"></td>
                                </#if>
                            </tr>
                    <#if (bundleName?length > 0)>
                        <#assign bundle_list = item_bundle>
                    </#if>
                </@listGroups>
                <#if bundle_list?has_content>
                    <#list bundle_list?sort_by("startdate")?sort_by("enddate") as item>
                        <#if (item.bundleName?length > 0)>
                            <#if (!a_subsidiariesLayout?seq_contains(record.subsidiary.id))>
                                <tr>
                                    <td colspan="18" ><span class="itemname">${item.bundleName}</span></td>
                                    <td align="center" colspan="6" line-height="150%">${item.quantity?string.number}</td>
                                    <td align="center" colspan="6"></td>
                                    <td align="right" colspan="6">${currency_symbol}${item.price?string["#,##0.00"]}</td>
                                    <td align="right" colspan="6">${currency_symbol}${item.amount?string["#,##0.00"]}</td>
                                </tr>
                            <#else>
                                <tr>
                                    <td colspan="18" ><span class="itemname">${item.bundleName}</span></td>
                                    <td align="center" colspan="6"></td>
                                    <td align="right" colspan="6"></td>
                                    <td align="right" colspan="6"></td>
                                    <td align="right" colspan="6" line-height="150%">${item.quantity?string.number}</td>
                                </tr>
                            </#if>
                            <tr>
                                <td colspan="24"> <#if item.startdate?has_content &&  item.enddate?has_content><span class="itemname">${handle.casewaretranslation.TERM}: ${item.totalMonths?round?string.number} ${handle.casewaretranslation.MONTHS}: </span> ${item.startdate} to ${item.enddate} </#if></td>
                                <td align="right" colspan="4"></td>
                                <td align="right" colspan="4"></td>
                                <td align="right" colspan="4"></td>
                            </tr>
                        </#if>
                    </#list>
                </#if>

            </table>

            <hr />
        </#if>
        <table class="total" style="width: 100%; margin-top: 10px;">
            <tr>
            <td colspan="4">&nbsp;</td>
                <td align="right" colspan="4">${record.subtotal@label}</td>
                <td align="right" colspan="2">${currency_symbol}${record.subtotal}</td>
            </tr>
            <#if record.taxtotal?has_content && record.taxtotal?is_number && (record.taxtotal gt 0 || record.taxtotal lt 0)>
                <#assign taxline1=record.taxtotal/record.subtotal*100>
                <#if record.shipcountry="CA">
            <tr>
                <td colspan="4">&nbsp;</td>
                <td align="right" colspan="4">GST/HST (${taxline1?string["0.##"]}%)</td>
            <td align="right" colspan="2">${currency_symbol}${record.taxtotal}</td>
            </tr>
                        <#elseif record.shipcountry="US">
                        <tr>
                <td colspan="4">&nbsp;</td>
                <td align="right" colspan="4">Taxes</td>
            <td align="right" colspan="2">${currency_symbol}${record.taxtotal}</td>
            </tr>

                  <#elseif record.subsidiary="AU01 CW Australia Pty Ltd.">
                        <tr>
                <td colspan="4">&nbsp;</td>
                <td align="right" colspan="4">GST (${taxline1?string["0.##"]}%)</td>
            <td align="right" colspan="2">${currency_symbol}${record.taxtotal}</td>
            </tr>
                   <#elseif record.subsidiary="DK01 CW Denmark ApS">
                        <tr>
                <td colspan="4">&nbsp;</td>
                <td align="right" colspan="4">${handle.casewaretranslation.VAT} (${taxline1?string["0.##"]}%)</td>
            <td align="right" colspan="2">${currency_symbol}${record.taxtotal}</td>
            </tr>
     <#elseif record.subsidiary="SG01 CW Asia Pte">
                        <tr>
                <td colspan="4">&nbsp;</td>
                <td align="right" colspan="4">GST (${taxline1?string["0.##"]}%)</td>
            <td align="right" colspan="2">${currency_symbol}${record.taxtotal}</td>
            </tr>
                    <#else>
                        <tr>
                <td colspan="4">&nbsp;</td>
                <td align="right" colspan="4">VAT (${taxline1?string["0.##"]}%)</td>
            <td align="right" colspan="2">${currency_symbol}${record.taxtotal}</td>
            </tr>
                    </#if>
                </#if>
        <#if record.tax2total?has_content && record.tax2total?is_number && (record.tax2total gt 0 || record.taxtotal lt 0)>
        <#assign taxline2=record.tax2total/record.subtotal*100>
        <tr>
                <td colspan="4">&nbsp;</td>
                <td align="right" colspan="4">PST (${taxline2?string["0.##"]}%)</td>
            <td align="right" colspan="2">${currency_symbol}${record.tax2total}</td>
            </tr>
        </#if>
 <#if record.currency="Danish Krone">
          <tr class="totalrow">
                <td colspan="4">&nbsp;</td>
                <td align="right" colspan="4"><b>${handle.casewaretranslation.TOTAL} DKK</b></td>
                <td align="right" colspan="2"><b>${currency_symbol}${record.total}</b></td>
            </tr>
                          <#else>
                            <tr class="totalrow">
                <td colspan="4">&nbsp;</td>
                <td align="right" colspan="4"><b>${handle.casewaretranslation.TOTAL} ${record.currency}</b></td>
                <td align="right" colspan="2"><b>${currency_symbol}${record.total}</b></td>
            </tr>
                            </#if>
        </table>

                            <#if record.custbody_cw_notaxexplanation?has_content>
<span class="terms"><i>${record.custbody_cw_notaxexplanation}</i></span><br /><br />
                              </#if>
                            
        <#if record.terms="Net 10">
        <span class="paymentterms">${handle.casewaretranslation.PAYMENTTERMS}: ${handle.casewaretranslation.NET10}</span><br /><br />
        <#elseif record.terms="Net 120">
        <span class="paymentterms">${handle.casewaretranslation.PAYMENTTERMS}: ${handle.casewaretranslation.NET120}</span><br /><br />
        <#elseif record.terms="Net 15">
        <span class="paymentterms">${handle.casewaretranslation.PAYMENTTERMS}: ${handle.casewaretranslation.NET15}</span><br /><br />
                <#elseif record.terms="Net 30">
        <span class="paymentterms">${handle.casewaretranslation.PAYMENTTERMS}: ${handle.casewaretranslation.NET30}</span><br /><br />
                          <#elseif record.terms="Net 45">
        <span class="paymentterms">${handle.casewaretranslation.PAYMENTTERMS}: ${handle.casewaretranslation.NET45}</span><br /><br />
                                    <#elseif record.terms="Net 60">
        <span class="paymentterms">${handle.casewaretranslation.PAYMENTTERMS}: ${handle.casewaretranslation.NET60}</span><br /><br />
                                              <#elseif record.terms="Net 90">
        <span class="paymentterms">${handle.casewaretranslation.PAYMENTTERMS}: ${handle.casewaretranslation.NET90}</span><br /><br />
    <#elseif record.terms="Due Upon Receipt">
        <span class="paymentterms">${handle.casewaretranslation.PAYMENTTERMS}: ${handle.casewaretranslation.DUEUPONRECEIPT}</span><br /><br />


                                                <#else>
		<span class="paymentterms">${handle.casewaretranslation.PAYMENTTERMS}: ${record.terms}</span><br /><br />
                            </#if>
  <#if record.custbody_cw_pdfnotes?has_content>
    <span class="terms">${handle.casewaretranslation.NOTES}: ${record.custbody_cw_pdfnotes}</span><br /><br />
    </#if>

    
<#if record.subsidiary.custrecord_cw_hidetermsconditions==true>
    <#if record.custbody_cw_ccsurchargedetails?has_content> <span class="terms"><b>${handle.casewaretranslation.CCSURCHARGE}: </b>${record.custbody_cw_ccsurchargedetails}</span><br /><br />
    </#if>
    <#if record.subsidiary="DK01 CW Denmark ApS">
             <span class="terms">${subsidiary.custrecord_cw_paymentmethod}</span><br /><br />
             <#if record.custbody_cw_fikcode?has_content>
                    <span class="terms">${record.custbody_cw_fikcode}</span><br /><br />
            </#if>
    <#else>
            <span class="terms">${handle.casewaretranslation.PAYMENTMETHODS} ${subsidiary.custrecord_cw_paymentmethod}.</span><br /><br />
            <span class="terms">${handle.casewaretranslation.PAYBYWIRE}:</span><br /><br />
    </#if>         
<span class="terms">${record.custbody_cwremitref}</span><br /><br />
                    <#if record.custbody_cwchequeinfo?has_content>
                    <span class="terms">${handle.casewaretranslation.PAYBYCHEQUE}:</span><br /><br />
                    <span class="terms">${record.custbody_cwchequeinfo}</span><br /><br />
                    </#if>
                      <#if record.subsidiary="EU02 CW NL B.V.">
                      <#elseif record.subsidiary="EU03 CW C2C B.V.">
                        <#elseif record.subsidiary="EU04 StriveCo GmbH">
                        <#else>
        <span class="terms">${handle.casewaretranslation.PAYBYBANKTRANSFER} ${subsidiary.custrecord_cw_pmtconfirmationemail}.</span><br /><br />
                          </#if>
        <span class="terms">${handle.casewaretranslation.BILLINGINQUIRIES} ${subsidiary.custrecord_cw_billingemail}.</span>
<#else>
  <#if record.subsidiary="CR01 CW LatAm" && record.entity.category="Government">
        <span class="terms">${handle.casewaretranslation.TERMS}</span><br />
                <span class="terms">${handle.casewaretranslation.INVTERMS1}</span><br />
                <span class="terms">${handle.casewaretranslation.INVTERMS2}</span><br />
                <span class="terms">${handle.casewaretranslation.INVTERMS3}</span><br />
                <span class="terms">${handle.casewaretranslation.INVTERMS4}</span><br />
                <span class="terms">${handle.casewaretranslation.INVTERMS5LATAMGOV}</span><br />
                <span class="terms">${handle.casewaretranslation.INVTERMS6}</span><br />
                <span class="terms">${handle.casewaretranslation.INVTERMS7LATAMGOV}</span><br />
                
    <#else>
    <span class="terms">${handle.casewaretranslation.TERMS}</span><br />
                <span class="terms">${handle.casewaretranslation.INVTERMS1}</span><br />
                <span class="terms">${handle.casewaretranslation.INVTERMS2}</span><br />
                <span class="terms">${handle.casewaretranslation.INVTERMS3}</span><br />
                <span class="terms">${handle.casewaretranslation.INVTERMS4}</span><br />
                <span class="terms">${handle.casewaretranslation.INVTERMS5}</span><br />
                <span class="terms">${handle.casewaretranslation.INVTERMS6}</span><br />
                <span class="terms">${handle.casewaretranslation.INVTERMS7}</span><br />
                <span class="terms">${handle.casewaretranslation.INVTERMS8}</span><br /><br />

      </#if>
                <#if record.custbody_cw_ccsurchargedetails?has_content> <span class="terms"><b>${handle.casewaretranslation.CCSURCHARGE}: </b>${record.custbody_cw_ccsurchargedetails}</span><br /><br />
                    </#if>
        <span class="terms">${handle.casewaretranslation.PAYMENTMETHODS} ${subsidiary.custrecord_cw_paymentmethod}.</span><br /><br />

        <span class="terms">${handle.casewaretranslation.PAYBYWIRE}:</span><br /><br />
        <span class="terms">${record.custbody_cwremitref}</span><br /><br />
                    <#if record.custbody_cwchequeinfo?has_content>
                    <span class="terms">${handle.casewaretranslation.PAYBYCHEQUE}:</span><br /><br />
                    <span class="terms">${record.custbody_cwchequeinfo}</span><br /><br />
                    </#if>
        <span class="terms">${handle.casewaretranslation.PAYBYBANKTRANSFER} ${subsidiary.custrecord_cw_pmtconfirmationemail}.</span><br /><br />
        <span class="terms">${handle.casewaretranslation.BILLINGINQUIRIES} ${subsidiary.custrecord_cw_billingemail}.</span>                               
</#if>
  
    </body>
</pdf>