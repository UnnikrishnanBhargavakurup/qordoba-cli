<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;" >
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:Page="urn:Page" xmlns:PageTimer="urn:PageTimer">

  <xsl:import href="_CurrencyField.xslt" />
  <xsl:import href="_BankLogo.xslt" />

  <xsl:variable name="is-banking-down">
    <xsl:choose>
      <xsl:when test="/Message/Header/User/Identity/Organisation/OrganisationTypeCode = 'ORGTYPE/DEMO'">false</xsl:when>
      <xsl:when test="boolean(//BankingServices/Unavailable)">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template name="BankNav">
    <xsl:param name="v2"/>
    <xsl:param name="selected"/>
    <xsl:param name="accountId"/>
    <xsl:param name="statementLines"/>

    <ul class="menu">
      <xsl:if test="$v2 = 'true'">
        <xsl:attribute name="class">group</xsl:attribute>
      </xsl:if>
      <xsl:if test="Page:UserIsInRole($Roles.Accountant) or Page:UserIsInRole($Roles.Administrator) or Page:UserIsInRole($Roles.CashbookClient)">
        <li>
          <xsl:if test="$selected = '1'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="/Bank/BankRec.aspx?accountID={$accountId}">
            <xsl:text>Reconcile</xsl:text>
            <xsl:if test="$statementLines != '' and $statementLines != 0">
              <xsl:text>&nbsp;(</xsl:text>
              <span id="itemsToRecCount">
                <xsl:value-of select="$statementLines"/>
              </span>
              <xsl:text>)</xsl:text>
            </xsl:if>
          </a>
        </li>
        <xsl:if test="Page:UserHasClaim($Claims.Banking.CashCoding.View) and //PageVars/HasFastCoding = 'True'">
          <li>
            <xsl:if test="$selected = '2'">
              <xsl:attribute name="class">selected</xsl:attribute>
            </xsl:if>
            <a href="/Bank/FastCoding.aspx?accountID={$accountId}">
              <xsl:text>Cash coding</xsl:text>
            </a>
          </li>
        </xsl:if>
      </xsl:if>
      <li>
        <xsl:if test="$selected = '3'">
          <xsl:attribute name="class">selected</xsl:attribute>
        </xsl:if>
        <a href="/Bank/Statements.aspx?accountID={$accountId}">
          <xsl:text>Bank statements</xsl:text>
        </a>
      </li>
      <li>
        <xsl:if test="$selected = '4'">
          <xsl:attribute name="class">selected</xsl:attribute>
        </xsl:if>
        <a href="/Bank/BankTransactions.aspx?accountID={$accountId}">
          <xsl:text>Account transactions</xsl:text>
        </a>
      </li>
    </ul>
  </xsl:template>

  <xsl:template name="XeroBalance">
    <xsl:param name="XeroBalance"/>
    <xsl:param name="BankBalance"/>

    <xsl:if test="
			($XeroBalance != $BankBalance) or
			($XeroBalance = $BankBalance and StatementLinesToReconcile > 0)
			">
      <div class="bank-balance">
        <xsl:if test="boolean(//PageVars/IsDashboard)">
          <label>
            <xsl:text>Balance in Xero</xsl:text>
          </label>
        </xsl:if>

        <span id="xero-bank-balance" data-balance="{$XeroBalance}">
          <xsl:value-of select="Page:FormatCurrencySigned($XeroBalance)"/>
        </span>
        <xsl:call-template name="Currency">
          <xsl:with-param name="BankBalance" select="$XeroBalance"/>
          <xsl:with-param name="Prefix">XeroBalance</xsl:with-param>
        </xsl:call-template>
        <xsl:if test="boolean(//PageVars/IsDashboard) = false()">
          <label>
            <xsl:text>Balance in Xero</xsl:text>
          </label>
        </xsl:if>
      </div>
    </xsl:if>

  </xsl:template>

  <xsl:template name="StatementBalance">
    <xsl:param name="BankBalance"/>
    <div class="statement-balance">
      <span data-automationid="statementBalance">
        <xsl:value-of select="Page:FormatCurrencySigned($BankBalance)"/>
      </span>
      <xsl:call-template name="Currency">
        <xsl:with-param name="BankBalance" select="$BankBalance"/>
        <xsl:with-param name="Prefix">BankBalance</xsl:with-param>
      </xsl:call-template>

      <label>
        <xsl:text>Statement Balance </xsl:text>
      </label>
    </div>
  </xsl:template>

  <xsl:template name="Currency">
    <xsl:param name="BankBalance"/>
    <xsl:param name="Prefix"/>

    <xsl:if test="CurrencyCode != ''">
      <xsl:call-template name="CurrencyField">
        <xsl:with-param name="Amount" select="$BankBalance"/>
        <xsl:with-param name="CurrencyCode" select="CurrencyCode"/>
        <xsl:with-param name="ID">
          <xsl:value-of select="$Prefix"/>_<xsl:value-of select="AccountID"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="LastImport">
    <div class="date-imported" id="import{CleanAccountID}">
      <xsl:choose>
        <xsl:when test="CurrentStatement/EndDate != ''">
          <xsl:value-of select="Page:FormatDate(CurrentStatement/EndDate, 'dmy')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>No transactions imported</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template name="BankReconciled">
    <xsl:param name="BankBalance"/>
    <xsl:param name="XeroBalance"/>
    <xsl:variable name="unbalanced">
      <xsl:if test="CurrentStatement/ImportedDateTimeUTC != '' and Page:FormatCurrencySigned($XeroBalance) != Page:FormatCurrencySigned($BankBalance)">true</xsl:if>
    </xsl:variable>
    <xsl:if test="StatementLinesToReconcile = 0">
      <xsl:choose>
        <xsl:when test="$unbalanced = 'true'">
          <a href="{Page:GetHelpUrl('Q_BankRecTips', false())}" target="_blank" class="unbalanced">Why is this different?</a>
        </xsl:when>
        <xsl:when test="CurrentStatement/ImportedDateTimeUTC != ''">
          <div class="reconciled">
            <em>
              <xsl:text>&nbsp;</xsl:text>
            </em>
            <span>
              <xsl:text>Reconciled</xsl:text>
            </span>
          </div>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

	<!-- Feed Errors -->
  <xsl:template name="feed-errors">
    <xsl:param name="bank-name"/>
    <xsl:param name="is-beta"/>
    <xsl:param name="header"/>
    <xsl:param name="last-refresh-status"/>

    <xsl:variable name="onclick">
      ChartOfAccounts.getBankFeedErrorHtml("<xsl:value-of select="$bank-name"/>", "<xsl:value-of select="AccountID"/>", "<xsl:value-of select="//PageVars/PageUrl"/>")
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$header = 'true'">
        <xsl:if test="not($last-refresh-status = $SiteHookupRefreshStatus.TransientError)">
          <div class="red-box">
            <xsl:text>There is a problem with this bank feed </xsl:text>
            <a href="javascript:" onclick="{$onclick}" class="xbtn large red exclude skip">Details...</a>
          </div>
        </xsl:if>
        <xsl:if test="$last-refresh-status = $SiteHookupRefreshStatus.TransientError">
          <div class="gray-box">
            <xsl:text>Your bank feed has temporarily stopped working </xsl:text>
            <a href="javascript:" onclick="{$onclick}" class="xbtn large gray exclude skip">Details...</a>
          </div>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <div class="imports feed-errors">
          <xsl:if test="not($last-refresh-status = $SiteHookupRefreshStatus.TransientError)">
            <xsl:if test="boolean(//PageVars/IsDashboard) = false()">
              <em class="icons warning">
                <xsl:text>&nbsp;</xsl:text>
              </em>
            </xsl:if>
            <strong>
              <xsl:text>There is a problem with this bank feed</xsl:text>
            </strong>
            <xsl:if test="boolean(//PageVars/IsDashboard)">
              <a class="red skip" href="javascript:" onclick="{$onclick}">
                <xsl:text>Details</xsl:text>
              </a>
            </xsl:if>
            <xsl:if test="boolean(//PageVars/IsDashboard) = false()">
              <a class="xbtn red skip" href="javascript:" onclick="{$onclick}">
                <xsl:text>Details...</xsl:text>
              </a>
            </xsl:if>
          </xsl:if>

          <xsl:if test="$last-refresh-status = $SiteHookupRefreshStatus.TransientError">
            <xsl:if test="boolean(//PageVars/IsDashboard) = false()">
              <em class="icons warning-gray">
                <xsl:text>&nbsp;</xsl:text>
              </em>
            </xsl:if>
            <xsl:text>Your bank feed has temporarily stopped working </xsl:text>
            <xsl:if test="boolean(//PageVars/IsDashboard)">
              <a class="gray skip" href="javascript:" onclick="{$onclick}">
                <xsl:text>Details</xsl:text>
              </a>
            </xsl:if>
            <xsl:if test="boolean(//PageVars/IsDashboard) = false()">
              <a class="xbtn gray skip" href="javascript:" onclick="{$onclick}">
                <xsl:text>Details...</xsl:text>
              </a>
            </xsl:if>
          </xsl:if>
        </div>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <!-- PayPal Feed Errors -->
  <xsl:template name="feed-errors-paypal">
    <xsl:param name="header"/>

    <xsl:choose>
      <xsl:when test="$header = 'true'">
        <div class="red-box">
          <xsl:text>Please check your Paypal settings</xsl:text>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="imports feed-errors" style="padding:5px 0 10px 100px !important;margin-top:0 !important;width:332px !important;">
          <em class="icons warning">
            <xsl:text>&nbsp;</xsl:text>
          </em>
          <strong>
            <xsl:text>Please check your Paypal settings</xsl:text>
          </strong>
        </div>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- Beta Feed Errors -->
  <xsl:template name="feed-errors-beta">
    <xsl:param name="header"/>

    <xsl:choose>
      <xsl:when test="$header = 'true'">
        <div class="blue-box">
          <xsl:text>A bank feed for this bank is currently in development. We will notify you via the Bank Account Dashboard when the feed provider makes this available.</xsl:text>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="imports feed-errors" style="padding:2px 0 6px !important;margin-top:0 !important;width:432px !important;">
          <xsl:text>A bank feed for this bank is currently in development. We will notify you via the Bank Account Dashboard when the feed provider makes this available.</xsl:text>
        </div>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <!--
	Bank states
	-->
  <xsl:template name="new-and-eligible">
    <xsl:param name="has-hookup"/>
    <xsl:param name="org-type"/>
    <xsl:param name="header"/>
    <xsl:param name="footer"/>
    <xsl:param name="menu"/>
    <xsl:param name="is-banking-down"/>
    <xsl:param name="is-generic"/>
    <xsl:param name="financial-connect-url"/>
    <xsl:param name="is-migrating"/>
    <xsl:param name="is-migrating-href"/>
    <xsl:param name="hookup"/>

    <xsl:variable name="href">
      <xsl:choose>
        <xsl:when test="$is-migrating = 'true'">
            <xsl:value-of select="concat($hookup/FinancialConnectStartUrl, 'FinancialInstitute?financialInstituteId=', $hookup/FinancialInstituteId, '&amp;referrer=getBankFeedsButton')" />
        </xsl:when>
        <xsl:when test="($has-hookup = 'false' or $org-type = 'ORGTYPE/DEMO') and $is-generic = 'false'">
          /Bank/FindBankFeed.aspx?accountID=<xsl:value-of select="AccountID"/>
        </xsl:when>
        <xsl:when test="$is-generic = 'true'">
            <xsl:value-of select="$financial-connect-url"/>
        </xsl:when>
        <xsl:otherwise>javascript:</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="onclick">
      <xsl:choose>
        <xsl:when test="$is-migrating = 'true'"> </xsl:when>
        <xsl:when test="$has-hookup = 'false' or $org-type = 'ORGTYPE/DEMO' or $is-generic = 'true'"> </xsl:when>
        <xsl:otherwise>
          ChartOfAccounts.activateBankFeeds('<xsl:value-of select="AccountID"/>', '<xsl:value-of select="//PageVars/PageUrl"/>'); return false;
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Banking is down banner -->
    <xsl:if test="$is-banking-down = 'true' and $header = 'true'">
      <div class="notify bg-orange bigger bankingdownbanner">
        <em>&#160;</em>
        <div class="message">
          <p>We're having trouble connecting to our banking services. Some functionality may be limited as a result of this. We should be back up and running shortly.</p>
        </div>
      </div>
    </xsl:if>

    <xsl:if test="$is-banking-down = 'false'">
      <xsl:choose>
        <xsl:when test="$header = 'true'">
          <div class="green-box">
            <a href="{$href}" onclick="{$onclick}" id="activateBtn_{CleanAccountID}" class="xbtn large green exclude">
              <xsl:text>Get bank feeds</xsl:text>
            </a>
            <xsl:text>Automatic bank feeds are available for this account </xsl:text>
          </div>
        </xsl:when>
        <xsl:when test="$footer = 'true'">
          <div class="imports">
            <xsl:if test="boolean(//PageVars/IsDashboard)">
              <div>Automatic bank feeds are available for this account</div>
              <a href="{$href}" onclick="{$onclick}" id="activateBtn_{CleanAccountID}" class="xbtn green" style="margin-left:4px;">
                <xsl:text>Get bank feeds</xsl:text>
              </a>
            </xsl:if>
            <xsl:if test="boolean(//PageVars/IsDashboard) = false()">
              <a href="{$href}" onclick="{$onclick}" id="activateBtn_{CleanAccountID}" class="xbtn green" style="margin-left:4px;">
                <xsl:text>Get bank feeds</xsl:text>
              </a>
              <xsl:text>Automatic bank feeds are available for this account</xsl:text>
            </xsl:if>

          </div>
        </xsl:when>
        <xsl:when test="$menu = 'true'">
          <a href="{$href}" onclick="{$onclick}" class="xbtn green skip plain">
            <xsl:text>Get bank feeds</xsl:text>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <div class="activate">
              <a href="{$href}" onclick="{$onclick}" id="activateBtn_{CleanAccountID}" class="xbtn big-text large green">
                  <xsl:text>Get bank feeds</xsl:text>
                </a>
              <div class="or">
                  <xsl:text> or </xsl:text>
              </div>
              <a href="/Bank/Import.aspx?accountID={AccountID}" class="manual">
                <xsl:text>manually import a statement</xsl:text>
              </a>
            </div>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

  </xsl:template>

  <xsl:template name="new-and-eligible-partner">
    <xsl:param name="partner-href"/>
    <xsl:param name="footer"/>
    <xsl:param name="header"/>
    <xsl:param name="menu"/>
    <xsl:param name="hookup"/>
    <xsl:param name="is-banking-down"/>
    <xsl:param name="is-migrating"/>
    <xsl:param name="is-migrating-href"/>

    <xsl:variable name="target">
      <xsl:choose>
        <xsl:when test="$hookup/IsFormPrePop != 'true' and
                        $hookup/IsNewAutoProvisionSource != 'true' and
                        $hookup/IsOAuth != 'true' and
                        $is-migrating = 'false'">_blank</xsl:when>
        <xsl:otherwise> </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="href">
        <xsl:choose>
            <xsl:when test="$is-migrating = 'true'">
                <xsl:value-of select="$is-migrating-href"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$partner-href"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:if test="$is-banking-down = 'false'">
      <xsl:choose>
        <xsl:when test="$header = 'true'">
          <div class="green-box">
            <xsl:text>Automatic bank feeds are available for this account </xsl:text>
            <a href="{$href}" target="{$target}" id="getFeedsFreeBtn_{CleanAccountID}" class="xbtn large green skip plain exclude">
              <xsl:text>Get bank feeds</xsl:text>
            </a>
          </div>
        </xsl:when>
        <xsl:when test="$footer = 'true'">
          <div class="imports">
            <xsl:if test="boolean(//PageVars/IsDashboard)">
              <div>Automatic bank feeds are available for this account </div>
              <a href="{$href}" target="{$target}" id="getFeedsFreeBtn_{CleanAccountID}" class="green xbtn skip plain">
                <xsl:text>Get bank feeds</xsl:text>
              </a>
            </xsl:if>
            <xsl:if test="boolean(//PageVars/IsDashboard) = false()">
              <a href="{$href}" target="{$target}" id="getFeedsFreeBtn_{CleanAccountID}" class="green xbtn skip plain">
                <xsl:text>Get Bank Feeds</xsl:text>
              </a>
              <xsl:text>Automatic bank feeds are available for this account </xsl:text>
            </xsl:if>
          </div>
        </xsl:when>
        <xsl:when test="$menu = 'true'">
          <a href="{$href}" target="{$target}" class="green xbtn skip plain">
            <xsl:text>Get bank feeds</xsl:text>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <div class="activate">
            <a href="{$href}" target="{$target}" id="getFeedsFreeBtn_{CleanAccountID}" class="big-text large green xbtn skip plain" style="margin-left:3px;">
              <xsl:text>Get Bank Feeds</xsl:text>
            </a>
            <div class="or">
              <xsl:text> or </xsl:text>
            </div>
            <a href="/Bank/Import.aspx?accountID={AccountID}" class="manual">
              <xsl:text>manually import a statement</xsl:text>
            </a>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

  </xsl:template>

  <xsl:template name="connecting-feed">
    <xsl:param name="header"/>

    <xsl:choose>
      <xsl:when test="$header = 'true'">
        <div class="blue-box">
          <strong>Connecting your automatic bank feed.</strong>
          <xsl:text> You will receive a notification when the feed is ready</xsl:text>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="authorize">
          <h3>
            <xsl:text>Connecting your automatic bank feed</xsl:text>
          </h3>
          <p>
            <xsl:text>You will receive a notification when the feed is ready</xsl:text>
          </p>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="connected-feed">
    <xsl:param name="header"/>
    <xsl:param name="footer"/>

    <xsl:choose>
      <xsl:when test="$header = 'true'">
        <div class="green-box">
          <strong>Ready to go!</strong>
          <xsl:text> Bank feeds are ready for this account </xsl:text>
          <a href="/Bank/ActivateBankFeed.aspx?accountID={AccountID}" id="authorizeBtn_{CleanAccountID}"  class="xbtn large green exclude">
            <xsl:text>Start bank feed now</xsl:text>
          </a>
        </div>
      </xsl:when>
      <xsl:when test="$footer = 'true'">
        <div class="imports">
          <xsl:if test="boolean(//PageVars/IsDashboard)">
            <div>Ready to go! Bank feeds are ready for this account </div>
            <a href="/Bank/ActivateBankFeed.aspx?accountID={AccountID}" id="authorizeBtn_{CleanAccountID}"  class="xbtn green exclude">
              <xsl:text>Start feed now</xsl:text>
            </a>
          </xsl:if>
          <xsl:if test="boolean(//PageVars/IsDashboard) = false()">
            <a href="/Bank/ActivateBankFeed.aspx?accountID={AccountID}" id="authorizeBtn_{CleanAccountID}"  class="xbtn green exclude">
              <xsl:text>Start feed now</xsl:text>
            </a>
            <xsl:text>Ready to go! Bank feeds are ready for this account </xsl:text>
          </xsl:if>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="authorize">
          <h3>
            <xsl:text>Ready to go!</xsl:text>
          </h3>
          <p class="no-margin">
            <xsl:text>Bank feeds are ready for this account</xsl:text>
          </p>
          <a href="/Bank/ActivateBankFeed.aspx?accountID={AccountID}" id="authorizeBtn_{CleanAccountID}" class="xbtn large big-text green">
            <xsl:text>Start bank feed now</xsl:text>
          </a>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="needs-authorization">
    <xsl:param name="header"/>
    <xsl:param name="hookup"/>

    <xsl:choose>
      <xsl:when test="$header = 'true'">
        <div class="green-box">
          <strong>Ready to go!</strong>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$hookup/DisplayName"/>
          <xsl:text> required addtional authorisation to complete the bank feed activation</xsl:text>
          <a onclick="ChartOfAccounts.authorizeMfa('{AccountID}', '{//PageVars/PageUrl}');" id="mfaAuthorizeBtn_{CleanAccountID}" class="xbtn large green exclude">
            <xsl:text>Authorize now</xsl:text>
          </a>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="authorize">
          <h3>
            <xsl:text>Ready to go!</xsl:text>
          </h3>
          <p>
            <xsl:value-of select="$hookup/DisplayName"/>
            <xsl:text> required addtional authorisation to complete the bank feed activation</xsl:text>
          </p>
          <a onclick="ChartOfAccounts.authorizeMfa('{AccountID}', '{//PageVars/PageUrl}');" id="mfaAuthorizeBtn_{CleanAccountID}" class="xbtn big-text large green">
            <xsl:text>Authorize now</xsl:text>
          </a>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="loading-feed">
    <xsl:param name="header"/>

    <xsl:choose>
      <xsl:when test="$header = 'true'">
        <div class="blue-box">
          <strong>Loading your bank transactions.</strong>
          <xsl:text> You will receive a notification when the transactions are ready</xsl:text>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="authorize">
          <h3>
            <xsl:text>Loading your bank transactions</xsl:text>
          </h3>
          <p>
            <xsl:text>You will receive a notification when the transactions are ready</xsl:text>
          </p>
        </div>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="no-transactions-imported">
    <xsl:param name="header"/>

    <xsl:choose>
      <xsl:when test="$header = 'true'">
        <div class="green-box" style="font-weight:bold;">
          <xsl:text>Get started by </xsl:text>
          <a style="margin:0;" href="/Bank/Import.aspx?accountID={AccountID}">
            <xsl:text>importing a bank statement</xsl:text>
          </a>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="authorize no-transactions">
          <h3>
            <xsl:text>No transactions imported</xsl:text>
          </h3>
          <p>
            <a href="/Bank/Import.aspx?accountID={AccountID}">Import a bank statement to get started</a>
          </p>
        </div>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>




  <!--
  BankAccount
  -->
  <xsl:template match="BankAccount">
    <xsl:param name="role"/>
    <xsl:param name="sortable"/>
    <xsl:param name="bank-header"/>
    <xsl:param name="show-refresh-button"/>
    <xsl:param name="hidden"/>

    <xsl:variable name="country">
      <xsl:choose>
        <xsl:when test="//Organisation/CountryCode = $Country.GreatBritain">uk</xsl:when>
        <xsl:when test="//Organisation/CountryCode = $Country.Australia">au</xsl:when>
        <xsl:when test="//Organisation/CountryCode = $Country.NewZealand">nz</xsl:when>
        <xsl:when test="//Organisation/CountryCode = $Country.UnitedStates">us</xsl:when>
        <xsl:otherwise>global</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="org-type">
      <xsl:value-of select="/Message/Header/User/Identity/Organisation/OrganisationTypeCode"/>
    </xsl:variable>

    <xsl:variable name="dashboard">
      <xsl:if test="IsShownOnDashboard = 1">true</xsl:if>
    </xsl:variable>

    <xsl:variable name="BankBalance">
      <xsl:if test="CurrentBalance = ''">
        <xsl:text>0.00</xsl:text>
      </xsl:if>
      <xsl:if test="CurrentBalance != ''">
        <xsl:choose>
          <xsl:when test="UnReconciledStatementLines != 0 and UnReconciledBankTransactions != 0">
            <xsl:value-of select="CurrentBalance + UnReconciledStatementLines + (0 - UnReconciledBankTransactions)"/>
          </xsl:when>
          <xsl:when test="UnReconciledStatementLines != 0">
            <xsl:value-of select="CurrentBalance + UnReconciledStatementLines"/>
          </xsl:when>
          <xsl:when test="UnReconciledBankTransactions != 0">
            <xsl:value-of select="CurrentBalance+(0 - UnReconciledBankTransactions)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="CurrentBalance"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="XeroBalance">
      <xsl:choose>
        <xsl:when test="CurrentBalance != ''">
          <xsl:value-of select="CurrentBalance"/>
        </xsl:when>
        <xsl:otherwise>0.00</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="hookup" select="key('hookup', normalize-space(translate(AccountID, $UpperCaseLetters, $LowerCaseLetters)))"/>

    <xsl:variable name="has-hookup">
      <xsl:choose>
        <xsl:when test="$hookup">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>




    <xsl:variable name="feed-country">
      <xsl:choose>
        <xsl:when test="$has-hookup='true'">
          <xsl:choose>
            <xsl:when test="$hookup/CountryCode = $Country.GreatBritain">uk</xsl:when>
            <xsl:when test="$hookup/CountryCode = $Country.Australia">au</xsl:when>
            <xsl:when test="$hookup/CountryCode = $Country.NewZealand">nz</xsl:when>
            <xsl:when test="$hookup/CountryCode = $Country.UnitedStates">us</xsl:when>
            <xsl:otherwise>global</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="//Organisation/CountryCode = $Country.GreatBritain">uk</xsl:when>
            <xsl:when test="//Organisation/CountryCode = $Country.Australia">au</xsl:when>
            <xsl:when test="//Organisation/CountryCode = $Country.NewZealand">nz</xsl:when>
            <xsl:when test="//Organisation/CountryCode = $Country.UnitedStates">us</xsl:when>
            <xsl:otherwise>global</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="is-partner-bank">
      <xsl:choose>
        <xsl:when test="$has-hookup = 'true'">
          <xsl:value-of select="$hookup/IsPartnerBank"/>
        </xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="is-active-partnerbank-with-loan-enquiry">
      <xsl:choose>
        <xsl:when test="number(HasAutomatedBankFeed) > 0 and $is-partner-bank = 'true' and $hookup/LoanEnquiryUrl != ''">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


    <xsl:variable name="bank">
      <xsl:choose>
        <xsl:when test="$hookup/Logo = 'BA'">ba</xsl:when>
        <xsl:when test="$hookup/Logo = 'NOB'">nob</xsl:when>
        <xsl:when test="$hookup/Logo = 'Bluered'">bluered</xsl:when>
        <xsl:when test="BankTypeCode = $BankType.PayPal">paypal</xsl:when>
        <xsl:when test="$has-hookup = 'true'">
          <xsl:choose>
            <xsl:when test="$hookup/Logo = 'ASB'">asb</xsl:when>
            <xsl:when test="$hookup/Logo = 'BankWest'">bankwest</xsl:when>
            <xsl:when test="$hookup/Logo = 'BNZ'">bnz</xsl:when>
            <xsl:when test="$hookup/Logo = 'CityNationalBank'">citynationalbank</xsl:when>
            <xsl:otherwise>global</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$country != 'global' and $org-type = 'ORGTYPE/DEMO'">
          <xsl:choose>
            <xsl:when test="BankCode = 'BANK/ASB'">asb</xsl:when>
            <xsl:when test="BankCode = 'BANK/BNZ'">bnz</xsl:when>
            <xsl:when test="BankCode = 'BANK/CITYNATIONALBANK'">citynationalbank</xsl:when>
            <xsl:when test="BankCode = 'BANK/BANKWEST'">bankwest</xsl:when>
            <xsl:otherwise>global</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>global</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="isMultiCurrency">
        <xsl:choose>
            <xsl:when test="$hookup/IsMultiCurrency = 'True'">true</xsl:when>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="matching-partner-currency">
      <xsl:choose>
        <xsl:when test="$is-partner-bank = 'true' and CurrencyCode = '' and $country = $feed-country">true</xsl:when>
        <xsl:when test="$is-partner-bank = 'true' and BankCode = 'BANK/HSBC' and $country = 'uk'">true</xsl:when>
        <xsl:when test="$is-partner-bank = 'true' and $hookup/IsMultiCurrency = 'true'">true</xsl:when>
        <xsl:when test="$is-partner-bank = 'true' and $country != $feed-country and $feed-country = 'au' and CurrencyCode = 'CURR/AUD' ">true</xsl:when>
        <xsl:when test="$is-partner-bank = 'true' and $country != $feed-country and $feed-country = 'nz' and CurrencyCode = 'CURR/NZD' ">true</xsl:when>
        <xsl:when test="$is-partner-bank = 'true' and $country != $feed-country and $feed-country = 'uk' and CurrencyCode = 'CURR/GBP' ">true</xsl:when>
        <xsl:when test="$is-partner-bank = 'true' and $country != $feed-country and $feed-country = 'us' and CurrencyCode = 'CURR/USD' ">true</xsl:when>
        <xsl:when test="$has-hookup = 'false'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="BankNumber">
      <xsl:choose>
        <xsl:when test="BankTypeCode = $BankType.CreditCard">
          <xsl:value-of select="concat('XXXX-XXXX-XXXX-', FormattedAccountNumber)"/>
        </xsl:when>
        <xsl:when test="$bank = 'paypal'"></xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="FormattedAccountNumber"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="yodlee-enabled-org">
      <xsl:choose>
        <xsl:when test="//Organisation/YodleeFeedsEnabled = 'True'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="yodlee-bank-feed-enabled">
      <xsl:choose>
        <xsl:when test="$yodlee-enabled-org = 'true' ">
          <xsl:value-of select="$hookup/IsYodleeAutomatedFeedEnabled"/>
        </xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="is-yodlee-feed">
      <xsl:choose>
        <xsl:when test="$hookup/IsYodleeProvidedHookUp = 'true' and $is-partner-bank = 'false'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!--Generic Hookup & Flags-->
     <xsl:variable name="is-generic-hookup" select="$hookup/IsGenericHookup"/>
     <xsl:variable name="canConnect" select="$hookup/CanConnect" />
     <xsl:variable name="canRefresh" select="$hookup/CanRefresh" />
     <xsl:variable name="canDeactivate" select="$hookup/CanDeactivate" />
     <xsl:variable name="canUpdateAuth" select="$hookup/CanUpdateAuth" />
    <!--End Generic Hookup & Flags-->

    <xsl:variable name="is-auto-provision-feed">
      <xsl:choose>
        <xsl:when test="$hookup/IsAutoProvision = 'true'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="is-new-auto-provision-feed">
      <xsl:choose>
        <xsl:when test="$hookup/IsNewAutoProvisionSource = 'true'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="can-disconnect-new-auto-provision-feed">
      <xsl:choose>
        <xsl:when test="$hookup/CanDisconnectNewAutoProvisionFeed = 'true'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="is-mfa-feed">
      <xsl:value-of select="$hookup/IsMFA"/>
    </xsl:variable>

    <xsl:variable name="is-active-feed">
      <xsl:choose>
        <xsl:when test="($is-yodlee-feed = 'true' or $is-generic-hookup = 'true') and $hookup/IsActivated = 'true'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

      <xsl:variable name="is-migrating">
          <xsl:choose>
              <xsl:when test="$hookup/IsMigratingToDirect = 'true'">true</xsl:when>
              <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
      </xsl:variable>

      <xsl:variable name="is-migrating-href">
          <xsl:if test="$is-migrating = 'true'">
            <xsl:choose>
              <xsl:when test="$hookup/IsFormPrePop = 'true'"><xsl:value-of select="concat('/Banking/Account/?id=', AccountID, '#existing')" /></xsl:when>
              <xsl:otherwise><xsl:value-of select="concat($hookup/FinancialConnectStartUrl, 'FinancialInstitute?financialInstituteId=', $hookup/FinancialInstituteId, '&amp;referrer=getBankFeedsButton')" /></xsl:otherwise>
            </xsl:choose>
          </xsl:if>
      </xsl:variable>

    <xsl:variable name="has-site-account">
      <xsl:choose>
        <xsl:when test="$hookup/HasSiteHookup = 'true'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="hookup-status">
      <xsl:choose>
        <xsl:when test="$has-hookup = 'true'">
          <xsl:value-of select="$hookup/Status"/>
        </xsl:when>
        <xsl:otherwise>Unknown</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="hookup-isrefreshing" select="$hookup/IsActivelyRefreshing" />

    <xsl:variable name="hookupID" select="$hookup/HookupId"/>

    <xsl:variable name="hookup-owner-id" select="$hookup/CreatedByUserId"/>

    <xsl:variable name="site-owner-id" select="$hookup/SiteHookupCreatedByUserId"/>

    <xsl:variable name="hookup-last-refresh-status" select="$hookup/MostRecentRefreshStatus" />

    <xsl:variable name="allow-non-owner-refresh">
      <xsl:choose>
        <xsl:when test="AllowNonOwnerRefresh=1">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="mfa-can-refresh">
      <xsl:choose>
        <xsl:when test="($hookup-owner-id = $site-owner-id and $hookup-owner-id = /Message/Header/User/Identity/UserID) or $allow-non-owner-refresh = 'true'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="mfa-can-manage">
      <xsl:choose>
        <xsl:when test="$hookup-owner-id = $site-owner-id and $hookup-owner-id = /Message/Header/User/Identity/UserID">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="activating">
      <xsl:choose>
        <xsl:when test="$hookup-status = $HookupStatus.WaitingForFirstRefresh or ($hookup-isrefreshing = 'true' and $is-active-feed = 'false')">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="start-feed">
      <xsl:choose>
        <xsl:when test="$hookup-status = $HookupStatus.Ok and $has-site-account = 'true' and $is-active-feed = 'false' and $hookup-isrefreshing = 'false'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="updating">
      <xsl:choose>
        <xsl:when test="$hookup-isrefreshing = 'true' and $is-active-feed = 'true'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="pending-mfa">
      <xsl:choose>
        <xsl:when test="$hookup-status = $HookupStatus.PendingMfa">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="has-import-feature">
      <xsl:choose>
        <xsl:when test="count(//OrganisationFeatures/OrganisationFeature[FeatureCode = $Feature.ImportBankStatements]) > 0">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="can-activate">
      <xsl:choose>
        <xsl:when test="
                  $has-import-feature = 'true' and
                  $yodlee-enabled-org = 'true' and
                  (($has-hookup = 'false' and $bank = 'global') or
                  ($is-yodlee-feed = 'true' and
                  $is-active-feed = 'false' and
                  $yodlee-bank-feed-enabled = 'true'))">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="has-transactions">
      <xsl:choose>
        <xsl:when test="boolean(CurrentStatement/ImportedDateTimeUTC) = false">false</xsl:when>
        <xsl:otherwise>true</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="is-beta" select="$hookup/IsBetaFeed"/>

    <xsl:variable name="is-processing">
      <xsl:choose>
        <xsl:when test="$updating = 'true' or $activating = 'true'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="feed-active">
      <xsl:if test="(number(HasAutomatedBankFeed) > 0 and ($is-partner-bank = 'true' or BankCode = 'BANK/PAYPAL')) or ($is-active-feed = 'true' and $is-processing = 'true')">true</xsl:if>
    </xsl:variable>

    <xsl:variable name="feed-active-mfa">
      <xsl:choose>
        <xsl:when test="(number(HasAutomatedBankFeed) > 0 and ($is-partner-bank = 'true' or BankCode = 'BANK/PAYPAL')) or ($is-active-feed = 'true')">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>

    </xsl:variable>

    <xsl:variable name="has-feed-errors">
      <xsl:choose>
        <xsl:when test="$hookup-status = $HookupStatus.SiteHookupError or
												$hookup-status = $HookupStatus.CredentialsFailure or
												$hookup-status = $HookupStatus.PendingMfa or
												$hookup-status = $HookupStatus.TransactionRetrievalError or
                        (
                          $hookup-status = $HookupStatus.MfaFailure
                          and
                          $feed-active-mfa = 'false'
                        )
                        and $is-processing = 'false'
                  ">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="new-and-eligible">
      <xsl:if test="
              ($feed-active != 'true' and ($has-hookup = 'false' or $hookup-status = $HookupStatus.Ok) and $has-site-account = 'false' and $can-activate = 'true') and
              $role != 'onramp' and
              $role != 'readonly'">true</xsl:if>
    </xsl:variable>

    <xsl:variable name="new-and-eligible-partner">
      <xsl:if test="
              $feed-active != 'true' and
              $has-import-feature = 'true' and
              (($is-partner-bank = 'true' and $matching-partner-currency = 'true') or $bank = 'paypal') and
              number(HasAutomatedBankFeed) = 0 and
              $role != 'onramp' and
              $role != 'readonly'">true</xsl:if>
    </xsl:variable>

    <xsl:variable name="can-cancel">
      <xsl:if test="($is-beta = 'false' and $is-active-feed = 'false' and $new-and-eligible = 'true' and $has-feed-errors = 'false') or ($has-feed-errors = 'true' and $hookup-owner-id = /Message/Header/User/Identity/UserID)">true</xsl:if>
    </xsl:variable>

      <xsl:variable name="financial-connect-start-url">
        <xsl:value-of select="concat($hookup/FinancialConnectStartUrl, '?sourceId=', $hookup/SourceId, '&amp;referrer=getBankFeedsButton')"/>
      </xsl:variable>

      <xsl:variable name="financial-connect-update-auth-url">
          <xsl:value-of select="$hookup/FinancialConnectUpdateAuthUrl"/>
      </xsl:variable>

    <xsl:variable name="partner-url">
      <xsl:choose>
        <xsl:when test="$bank = 'paypal' or BankCode = 'BANK/PAYPAL'">
          <xsl:value-of select="Page:GetHelpUrl('BankAccounts_PayPal', false())"/>
        </xsl:when>
        <xsl:when test="$hookup/HelpUrl != ''">
          <xsl:choose>
            <xsl:when test="$hookup/IsNewAutoProvisionSource = 'true'">
              <xsl:value-of select="concat($hookup/FinancialConnectStartUrl, '?sourceId=', $hookup/SourceId, '&amp;referrer=getBankFeedsButton')"/>
            </xsl:when>
            <xsl:when test="$hookup/IsFormPrePop = 'true'">
              <xsl:value-of select="concat('/Banking/Account/?id=', AccountID, '#existing')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$hookup/HelpUrl"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$is-migrating = 'true'">
            <xsl:value-of select="concat($hookup/FinancialConnectStartUrl, 'FinancialInstitute?financialInstituteId=', $hookup/FinancialInstituteId, '&amp;referrer=getBankFeedsButton')" />
        </xsl:when>
        <xsl:when test="$hookup/IsOAuth = 'true'">
          <xsl:value-of select="concat($hookup/FinancialConnectStartUrl, '?sourceId=', $hookup/SourceId, '&amp;referrer=getBankFeedsButton')"/>
        </xsl:when>
        <xsl:otherwise>#</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="show-errors">
      <xsl:if test="
				(BankCode = 'BANK/PAYPAL' and number(HasAutomatedBankFeed) > 0 and AutomatedBankFeedStatus = 'IMPORTSETUP/ERROR')
				or
				($is-beta = 'false' and $is-yodlee-feed='true' and $is-active-feed='true' and $has-feed-errors = 'true' and $hookup-isrefreshing = 'false')
				or
				$has-feed-errors = 'true' and $hookup-isrefreshing = 'false'
				">true</xsl:if>
    </xsl:variable>



    <xsl:variable name="connecting-feed">
      <xsl:if test="
							$activating = 'true' and
                            $is-generic-hookup = 'false' and
							$is-active-feed = 'false' and
							$role != 'onramp' and
							$role != 'readonly'">true</xsl:if>
    </xsl:variable>

    <xsl:variable name="connected-feed">
      <xsl:if test="
							$start-feed = 'true' and
                            $is-generic-hookup = 'false' and
							$role != 'onramp' and
							$role != 'readonly'">true</xsl:if>
    </xsl:variable>

    <xsl:variable name="needs-authorization">
      <xsl:if test="
								$pending-mfa = 'true' and
								$has-transactions = 'false' and
								$role != 'onramp' and
								$role != 'readonly'">true</xsl:if>
    </xsl:variable>

    <xsl:variable name="loading-feed">
      <xsl:if test="
							($updating = 'true' or $activating = 'true') and
							$is-active-feed = 'true' and
							$role != 'onramp' and
							$role != 'readonly'">true</xsl:if>
    </xsl:variable>

    <xsl:variable name="no-transactions-imported">
      <xsl:if test="string-length(CurrentStatement/EndDate) = 0">true</xsl:if>
    </xsl:variable>

    <xsl:variable name="show-update-login">
      <xsl:if test="
              (
                $is-mfa-feed = 'true' and
							  $hookup-owner-id = $site-owner-id and
							  $hookup-owner-id = /Message/Header/User/Identity/UserID
                and
                $is-active-feed= 'true'
              )
              or
              (
                $is-mfa-feed = 'false'
                and
                $is-yodlee-feed = 'true'
                and
                $is-active-feed= 'true'
              )
              ">true</xsl:if>
    </xsl:variable>

		<!--<h1>
      FeedActive: <xsl:value-of select="$feed-active"/><br />
      IsActiveFeed: <xsl:value-of select="$is-active-feed"/><br />
      Hookup Status: <xsl:value-of select="$hookup-status"/><br />
      Can Cancel: <xsl:value-of select ="$can-cancel"/><br />
      Show Update Login: <xsl:value-of select="$show-update-login "/>
    </h1>-->

    <xsl:variable name="feeds-column">
      <xsl:if test="
							(
                $feed-active = 'true'
                or
							  (
                  $is-active-feed = 'true' and
                  $is-processing = 'false'
                )
                or
							  $can-cancel = 'true' or
							  $show-update-login = 'true' or
							  $start-feed = 'true' or
							  $new-and-eligible-partner = 'true' or
							  $new-and-eligible = 'true' or
                              $is-generic-hookup = 'true'
              )
              or
              ($hookup-status = $HookupStatus.WaitingForFirstRefresh)
              and
              $hookup-status != 'BankNameUnknown'
              ">true</xsl:if>
    </xsl:variable>


      <xsl:variable name="menu">
      <dl class="select list anchor-right wide-bank">
        <dt>
          <div>
              <xsl:choose>
                  <xsl:when test="boolean(//PageVars/IsDashboard)">
                      <xsl:text>Manage</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                      <xsl:text>Manage Account</xsl:text>
                  </xsl:otherwise>
              </xsl:choose>
            <span>
              <xsl:text>&nbsp;</xsl:text>
            </span>
          </div>
        </dt>
        <dd class="manage-account-menu">
          <div class="manage-account-menu-columns">
            <div class="manage-account-menu-column">
              <div class="manage-account-menu-column-header">Find</div>
              <ul>
                <li class="manage-account-menu-item">
                  <a href="/Bank/BankTransactions.aspx?accountID={AccountID}">
                    Account Transactions
                  </a>
                </li>
                <li class="manage-account-menu-item">
                  <a href="/Bank/Statements.aspx?accountID={AccountID}">
                    Bank Statements
                  </a>
                </li>
              </ul>
            </div>
            <div class="manage-account-menu-column">
              <div class="manage-account-menu-column-header">New</div>
              <ul>
                <li class="manage-account-menu-item">
                  <a href="/Bank/EditCashReceipt.aspx?accountID={AccountID}&amp;type={$InvoiceType.CashPaid}">
                    Spend Money
                  </a>
                </li>
                <li class="manage-account-menu-item">
                  <a href="/Bank/EditCashReceipt.aspx?accountID={AccountID}&amp;type=INVOICETYPE/CASHREC">
                    Receive Money
                  </a>
                </li>
                <li class="manage-account-menu-item">
                  <a href="/Bank/Transfer.aspx?accountID={AccountID}">
                    Transfer Money
                  </a>
                </li>
              </ul>
            </div>
            <div class="manage-account-menu-column">
              <div class="manage-account-menu-column-header">Reconcile</div>
              <ul>
                <li class="manage-account-menu-item">
                  <a href="/Bank/BankRec.aspx?accountID={AccountID}">
                    Reconcile Account
                  </a>
                </li>
                <li class="manage-account-menu-item">
                  <a href="/Bank/BankRecRules.aspx">
                    Bank Rules
                  </a>
                </li>
                <li class="manage-account-menu-item">
                  <a>
                    <xsl:attribute name="href">
                      <xsl:text>/Reports/report</xsl:text>
                      <xsl:if test="$role = 'accountant'">2</xsl:if>
                      <xsl:text>.aspx?statement=AE21E0AE-C1B1-4450-A99F-89F13258F6A8&amp;bankAccountID=</xsl:text>
                      <xsl:value-of select="AccountID"/>
                    </xsl:attribute>
                    <xsl:text>Reconciliation Report</xsl:text>
                  </a>
                </li>
                <xsl:if test="count(//OrganisationFeatures/OrganisationFeature[FeatureCode = $Feature.ImportBankStatements]) > 0 or $role = 'accountant'">
                  <li class="manage-account-menu-item">
                    <a href="/Bank/Import.aspx?accountID={AccountID}">
                      Import a Statement
                    </a>
                  </li>
                </xsl:if>
              </ul>
            </div>
            <xsl:if test="$is-active-partnerbank-with-loan-enquiry = 'true'">
              <div class="manage-account-menu-column">
                <div class="manage-account-menu-column-header">NAB Services</div>
                <ul>
                  <li class="manage-account-menu-item">
                    <a href="{$hookup/LoanEnquiryUrl}?orgShortCode={//PageVars/OrganisationShortCode}&amp;accountId={AccountID}" title="Loan Enquiry">
                      Loan Enquiry
                    </a>
                  </li>
                </ul>
              </div>
            </xsl:if>
            <xsl:if test="$feeds-column = 'true' and $is-banking-down = 'false'">
              <div class="manage-account-menu-column">
                <div class="manage-account-menu-column-header">
                  <xsl:choose>
                    <xsl:when test="$is-auto-provision-feed = 'true'">
                      <xsl:text>Direct Connect</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>Bank Feeds</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
                <xsl:choose>
                  <xsl:when test="$new-and-eligible-partner = 'true'">
                    <xsl:call-template name="new-and-eligible-partner">
                      <xsl:with-param name="menu">true</xsl:with-param>
                      <xsl:with-param name="partner-href" select="$partner-url"/>
                      <xsl:with-param name="hookup" select="$hookup"/>
                      <xsl:with-param name="is-banking-down" select="$is-banking-down"/>
                      <xsl:with-param name="is-migrating" select="$is-migrating"/>
                      <xsl:with-param name="is-migrating-href" select="$is-migrating-href"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="$new-and-eligible = 'true' or $canConnect = 'true'">
                    <xsl:call-template name="new-and-eligible">
                      <xsl:with-param name="menu">true</xsl:with-param>
                      <xsl:with-param name="has-hookup" select="$has-hookup"/>
                      <xsl:with-param name="org-type" select="$org-type"/>
                      <xsl:with-param name="is-banking-down" select="$is-banking-down"/>
                      <xsl:with-param name="is-generic" select="$is-generic-hookup"/>
                      <xsl:with-param name="financial-connect-url" select="$financial-connect-start-url"/>
                      <xsl:with-param name="is-migrating" select="$is-migrating"/>
                      <xsl:with-param name="is-migrating-href" select="$is-migrating-href"/>
                      <xsl:with-param name="hookup" select="$hookup"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="$is-partner-bank = 'true'">
                    <xsl:if test="AutomatedBankFeedStatus = 'IMPORTSETUP/SUCCESS'">
                        <p class="green">Activated</p>
                    </xsl:if>
                    <ul>
                        <xsl:if test="$is-migrating = 'true'">
                            <li class="manage-account-menu-item">
                                <a href="{$is-migrating-href}">
                                    Convert to Direct
                                </a>
                            </li>
                        </xsl:if>
                        <xsl:if test="$canDeactivate = 'true'">
                          <li class="manage-account-menu-item">
                            <xsl:choose>
                              <xsl:when test="$is-new-auto-provision-feed = 'true' and $can-disconnect-new-auto-provision-feed = 'false'">
                                <a href="https://help.xero.com/au/BankFeedsDirectStop$Online" target="_blank" class="exclude">Disconnect</a>
                              </xsl:when>
                              <xsl:otherwise>
                                <a href="javascript:" onclick="ChartOfAccounts.deactivateBankFeedHtml('{AccountID}','PartnerBankFeed','{$hookup/BankName}');">
                                  Disconnect
                                </a>
                              </xsl:otherwise>
                            </xsl:choose>
                          </li>
                        </xsl:if>
                        <xsl:if test="//PageVars/CanTransferAccounts = 'True'">
                            <li class="manage-account-menu-item">
                                <xsl:choose>
                                    <xsl:when test="//PageVars/IsHighRiskLogin = 'true'">
                                        <a href="{Page:GetHelpUrl('BankFeedsDirectTransfer', false())}">Transfer Feed</a>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <a href="{//PageVars/FinancialConnectBaseUrl}account/transfer/{AccountID}?returnUrl={//PageVars/FinancialConnectReturnUrl}">Transfer Feed</a>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </li>
                        </xsl:if>
                    </ul>
                  </xsl:when>
                  <xsl:when test="($is-mfa-feed = 'true' and $mfa-can-refresh = 'false' and $is-active-feed = 'true')">
                    <p class="green">Activated</p>
                  </xsl:when>
                  <xsl:when test="((($is-processing = 'false' and $is-mfa-feed = 'false') or ($is-mfa-feed = 'true' and $mfa-can-refresh = 'true') or $is-generic-hookup = 'true') and $is-active-feed = 'true')">
                    <ul>
                        <xsl:if test="$is-migrating = 'true'">
                           <li class="manage-account-menu-item">
                            <a href="{$is-migrating-href}">
                              Convert to Direct
                            </a>
                          </li>
                        </xsl:if>
                      <xsl:if test="$hookup-isrefreshing = 'false' and $canRefresh = 'true'">
                          <li class="manage-account-menu-item">
                            <a href="javascript:" onclick="ChartOfAccounts.refreshBankFeed('{AccountID}', '{$hookupID}', {$is-mfa-feed});">
                              Refresh Bank Feed
                            </a>
                          </li>
                      </xsl:if>
                      <xsl:if test="($mfa-can-manage = 'true' and (($is-mfa-feed = 'true') or ($is-mfa-feed = 'false' and $show-update-login = 'true'))) or $canUpdateAuth = 'true'">
                        <li class="manage-account-menu-item">
                            <xsl:choose>
                                <xsl:when test="$is-generic-hookup = 'true'">
                                    <a href="{$financial-connect-update-auth-url}">
                                        Update Feed Login
                                    </a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <a href="javascript:" onclick="ChartOfAccounts.updateBankLogin('{AccountID}', '{//PageVars/PageUrl}');">
                                        Update Feed Login
                                    </a>
                                </xsl:otherwise>
                            </xsl:choose>
                        </li>
                      </xsl:if>
                        <xsl:if test ="$is-yodlee-feed = 'true' or $canDeactivate = 'true'">
                        <li class="manage-account-menu-item">
                          <a href="javascript:" onclick="ChartOfAccounts.deactivateBankFeedHtml('{AccountID}');">
                            Deactivate Feed
                          </a>
                        </li>
                      </xsl:if>
                    </ul>
                  </xsl:when>
                  <xsl:when test="$is-yodlee-feed = 'true'">
                      <xsl:choose>
                          <xsl:when test="$can-cancel = 'true' and $has-site-account = 'true' and $start-feed = 'false'">
                            <p class="red">Not activated</p>
                            <ul>
                              <xsl:if test="$hookup-status = $HookupStatus.MfaFailure">
                                <li class="manage-account-menu-item">
                                  <a href="javascript:" onclick="ChartOfAccounts.refreshBankFeed('{AccountID}', '{$hookupID}', {$is-mfa-feed});">
                                    Refresh Bank Feed
                                  </a>
                                </li>
                              </xsl:if>
                              <xsl:if test="$hookup-owner-id = /Message/Header/User/Identity/UserID">
                                <li class="manage-account-menu-item">
                                  <a href="javascript:" onclick="ChartOfAccounts.updateBankLogin('{AccountID}', '{//PageVars/PageUrl}')">
                                    Update Feed Login
                                  </a>
                                </li>
                              </xsl:if>
                              <li class="manage-account-menu-item">
                                <a href="javascript:" class="exclude">
                                  <xsl:attribute name="onclick">
                                    XERO.widget.Messages.confirmButtons('DeactivateFeed', 'cancel', 'activation', false, ['<xsl:value-of select="AccountID"/>', 'cancelling', 'cancelled'], 'Yes', 'No')
                                  </xsl:attribute>
                                  <xsl:text>Cancel Activation</xsl:text>
                                </a>
                              </li>
                            </ul>
                          </xsl:when>
                          <xsl:when test="$hookup-status = $HookupStatus.WaitingForFirstRefresh and $hookup-owner-id = /Message/Header/User/Identity/UserID">
                            <p class="red">Not activated</p>
                            <ul>
                              <li class="manage-account-menu-item">
                                <a href="javascript:" class="exclude">
                                  <xsl:attribute name="onclick">
                                    XERO.widget.Messages.confirmButtons('DeactivateFeed', 'cancel', 'activation', false, ['<xsl:value-of select="AccountID"/>', 'cancelling', 'cancelled'], 'Yes', 'No')
                                  </xsl:attribute>
                                  <xsl:text>Cancel Activation</xsl:text>
                                </a>
                              </li>
                            </ul>
                          </xsl:when>
                          <xsl:when test="$show-update-login = 'true'">
                            <a href="javascript:" onclick="ChartOfAccounts.updateBankLogin('{AccountID}', '{//PageVars/PageUrl}')" class="xbtn blue skip plain">
                              Update Login
                            </a>
                          </xsl:when>
                          <xsl:when test="$start-feed = 'true'">
                            <a href="/Bank/ActivateBankFeed.aspx?accountID={AccountID}" class="xbtn green skip plain">
                              <xsl:text>Start feed now</xsl:text>
                            </a>
                          </xsl:when>
                      </xsl:choose>
                  </xsl:when>
                </xsl:choose>
                <ul>
                  <li class="manage-account-menu-item">
                    <a class="skip exclude" href="http://www.xero.com/blog/bank-feed-status" target="_blank">
                      View Status Updates
                    </a>
                  </li>
                </ul>
              </div>
            </xsl:if>
          </div>
          <div class="manage-account-menu-footer">
            <xsl:if test="boolean(//PageVars/IsDashboard)">
              <div class="manage-account-menu-summary-text">
                <xsl:value-of select="$BankNumber"/>&nbsp;<xsl:value-of select="Name"/>
              </div>
            </xsl:if>
            <xsl:if test="$is-banking-down = 'false'">
              <a class="manage-account-menu-edit-link" href="javascript:" onclick="ChartOfAccounts.getEditBankAccountHtml(false, '{AccountID}'); return false;">Edit Account Details</a>
            </xsl:if>
          </div>
        </dd>
        <!-- NOTE: A popup/tooltip that advertises the NAB loan enquiry feature.
                   When we can stop advertising the feature, this section can be
                   deleted -->
        <xsl:if test="$is-active-partnerbank-with-loan-enquiry = 'true'">
          <div class="manage-account-nab-popup">
            <img src="/Common/Images/banks/xero-nab.svg" alt="Xero + NAB logos" class="manage-account-nab-popup-logo"/>
            <div>You can now make a NAB loan enquiry from the Manage menu</div>
            <div class="manage-account-nab-popup-buttons">
              <a href="javascript:void(0)" class="xbtn large exclude" rel="dismiss-nab-popup">Dismiss</a>
              <a href="{$hookup/LoanEnquiryUrl}?orgShortCode={//PageVars/OrganisationShortCode}&amp;accountId={AccountID}"
                 class="xbtn large blue exclude" rel="learn-more">Learn more</a>
            </div>
          </div>
        </xsl:if>
      </dl>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$bank-header != 'true'">
        <div>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="boolean(//PageVars/IsOldDashboard)">dashboard-box<xsl:if test="$hidden = 'true'"> hide</xsl:if></xsl:when>
              <xsl:otherwise>dashboard-box-inner</xsl:otherwise>
             </xsl:choose>
          </xsl:attribute>
          <xsl:if test="boolean(//PageVars/IsOldDashboard)">
            <xsl:attribute name="data-type">bank-<xsl:value-of select="CleanAccountID" /></xsl:attribute>
            <xsl:attribute name="data-id"><xsl:value-of select="AccountID" /></xsl:attribute>
            <xsl:attribute name="data-draggable">ddgroup</xsl:attribute>
            <xsl:attribute name="data-hidden"><xsl:value-of select="$hidden" /></xsl:attribute>
          </xsl:if>

          <div>
            <xsl:attribute name="class">
              <xsl:text>bank</xsl:text>
              <xsl:if test="$bank = 'citynationalbank' or $bank = 'bankofmelbourne'">
                <xsl:text> </xsl:text>
                <xsl:value-of select="$bank"/>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="$role = 'onramp'">
                  <xsl:text> managed-client</xsl:text>
                </xsl:when>
                <xsl:when test="$role = 'readonly'">
                  <xsl:text> readonly</xsl:text>
                </xsl:when>
              </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="boolean(//PageVars/IsDashboard)">
                  <div id="bank-{CleanAccountID}-header" style="width:100%" class="edit-hdr bank-header">
                  <span  id="{AccountID}" href="/Bank/BankTransactions.aspx?accountID={AccountID}" class="bank-name">
                    <xsl:if test="$bank = 'global'">
                      <xsl:attribute name="class">bank-name global</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$role = 'onramp'">
                      <xsl:attribute name="href">javascript:</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$bank = 'paypal'">
                      <xsl:attribute name="class">bank-name paypal</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="Name"/>
                    <span>
                      <xsl:value-of select="$BankNumber"/>
                    </span>
                  </span>

                  <xsl:call-template name="BankLogo">
                    <xsl:with-param name="bank" select="$bank"/>
                    <xsl:with-param name="logoUrl" select="$hookup/LogoUrl" />
                  </xsl:call-template>
                  <xsl:if test="
									  $role != 'onramp' and
									  $role != 'readonly'">
                    <xsl:copy-of select="$menu"/>
                  </xsl:if>

                  <a href="#" class="box-toggle hide">Hide</a>
                  <a href="#" class="box-toggle show">Show</a>

                </div>
                <div style="width:100%" class="bank-header">
                  <a id="{AccountID}" href="/Bank/BankTransactions.aspx?accountID={AccountID}" class="bank-name">
                    <xsl:if test="$bank = 'global'">
                      <xsl:attribute name="class">bank-name global</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$role = 'onramp'">
                      <xsl:attribute name="href">javascript:</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$bank = 'paypal'">
                      <xsl:attribute name="class">bank-name paypal</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="Name"/>
                    <span>
                      <xsl:value-of select="$BankNumber"/>
                    </span>
                  </a>
                  <xsl:call-template name="BankLogo">
                    <xsl:with-param name="bank" select="$bank"/>
                    <xsl:with-param name="logoUrl" select="$hookup/LogoUrl" />
                  </xsl:call-template>
                  <xsl:if test="
									  $role != 'onramp' and
									  $role != 'readonly'">
                    <xsl:copy-of select="$menu"/>
                  </xsl:if>
                </div>
								<xsl:if test="
									  $show-errors = 'true' and
									  $role != 'onramp' and
									  $role != 'readonly'">
									<xsl:choose>
										<xsl:when test="$is-beta = 'true'">
											<xsl:call-template name="feed-errors-beta"/>
										</xsl:when>
										<xsl:when test="$bank = 'paypal'">
											<xsl:call-template name="feed-errors-paypal"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:if test="$hookup-isrefreshing = 'false'">
												<xsl:call-template name="feed-errors">
													<xsl:with-param name="bank-name" select="$hookup/BankName"/>
                          <xsl:with-param name="last-refresh-status" select="$hookup-last-refresh-status"/>
												</xsl:call-template>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:when>
              <xsl:otherwise>
                <div id="bank-{CleanAccountID}-header" style="width:100%" class="bank-header">
                  <a id="{AccountID}" href="/Bank/BankTransactions.aspx?accountID={AccountID}" class="bank-name">
                    <xsl:if test="$bank = 'global'">
                      <xsl:attribute name="class">bank-name global</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$role = 'onramp'">
                      <xsl:attribute name="href">javascript:</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$bank = 'paypal'">
                      <xsl:attribute name="class">bank-name paypal</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="Name"/>
                    <span>
                      <xsl:value-of select="$BankNumber"/>
                    </span>
                  </a>

                  <xsl:call-template name="BankLogo">
                    <xsl:with-param name="bank" select="$bank"/>
                    <xsl:with-param name="logoUrl" select="$hookup/LogoUrl" />
                  </xsl:call-template>

                    <xsl:if test="$show-errors != 'true' and $is-migrating = 'true' and $hookup/IsFormPrePop = 'true'">
                        <div class="feed-errors" style="top:10px;">
                            <em class="icons spanner" style="margin-top:3px;">
                                <xsl:text>&nbsp;</xsl:text>
                            </em>
                            <label for="bank_{position()}" style="padding-top: 6px;padding-right: 2px; padding-left:8px; vertical-align:middle;" >
                                <xsl:text>Your bank feed needs updating.</xsl:text>
                            </label>
                            <xsl:if test="$hookup/HelpUrl != ''">
                              <a href="{$hookup/HelpUrl}" style="padding-top: 6px;padding-right: 10px; padding-left:2px; vertical-align:middle;" >Learn more</a>
                            </xsl:if>
                            <a class="large xbtn" href="{$is-migrating-href}" id="activateBtn_{CleanAccountID}" style="width: 39px;">Update</a>
                        </div>
                    </xsl:if>

                  <xsl:if test="
									  $role != 'onramp' and
									  $role != 'readonly'">
                    <xsl:copy-of select="$menu"/>
                  </xsl:if>

                  <xsl:if test="
									  $show-errors = 'true' and
									  $role != 'onramp' and
									  $role != 'readonly'">
                    <xsl:choose>
                      <xsl:when test="$is-beta = 'true'">
                        <xsl:call-template name="feed-errors-beta"/>
                      </xsl:when>
                      <xsl:when test="$bank = 'paypal'">
                        <xsl:call-template name="feed-errors-paypal"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:if test="$hookup-isrefreshing = 'false'">
                          <xsl:call-template name="feed-errors">
                            <xsl:with-param name="bank-name" select="$hookup/BankName"/>
                            <xsl:with-param name="last-refresh-status" select="$hookup-last-refresh-status"/>
                          </xsl:call-template>
                        </xsl:if>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:if>
                </div>
              </xsl:otherwise>
            </xsl:choose>
            <div class="content">

              <xsl:if test="boolean(//PageVars/IsOldDashboard) and $is-banking-down = 'true'">
                <div class="bankingdown">
                  We're having trouble connecting to our banking services. Some functionality may be limited as a result of this. We should be back up and running shortly.
                </div>
              </xsl:if>

              <div class="balance">
                <xsl:if test="boolean(//PageVars/IsDashboard)">
                  <xsl:if test="CurrentStatement/ImportedDateTimeUTC != '' and StatementLinesToReconcile > 0 and $role != 'readonly'">
                    <xsl:if test="$role = 'onramp'">
                      <a class="xbtn blue" href="/Bank/BankRecComments.aspx?accountID={AccountID}">
                        <xsl:text>Add comments &#8250;</xsl:text>
                      </a>
                    </xsl:if>
                    <xsl:if test="$role != 'onramp'">
                      <a class="xbtn blue" href="/Bank/BankRec.aspx?accountID={AccountID}">
                        <xsl:text>Reconcile </xsl:text>
                        <span id="itemsToRecCount">
                          <xsl:value-of select="StatementLinesToReconcile"/>
                        </span>
                        <xsl:text> item</xsl:text>
                        <xsl:if test="StatementLinesToReconcile > 1">s</xsl:if>
                      </a>
                    </xsl:if>
                  </xsl:if>
                  <xsl:call-template name="BankReconciled">
                    <xsl:with-param name="BankBalance" select="$BankBalance"/>
                    <xsl:with-param name="XeroBalance" select="$XeroBalance"/>
                  </xsl:call-template>
                  <div class="summary-row">
                    <xsl:call-template name="XeroBalance">
                      <xsl:with-param name="BankBalance" select="$BankBalance"/>
                      <xsl:with-param name="XeroBalance" select="$XeroBalance"/>
                    </xsl:call-template>

                    <div class="statement-balance">
                      <label>
                        <xsl:text>Statement balance </xsl:text>
                        <xsl:choose>
                          <xsl:when test="CurrentStatement/EndDate != ''">
                            <xsl:text>(</xsl:text>
                            <xsl:value-of select="Page:FormatDate(CurrentStatement/EndDate, 'dm')"/>
                            <xsl:text>)</xsl:text>
                          </xsl:when>
                        </xsl:choose>
                      </label>
                      <span data-automationid="statementBalance">
                        <xsl:value-of select="Page:FormatCurrencySigned($BankBalance)"/>
                      </span>
                      <xsl:call-template name="Currency">
                        <xsl:with-param name="BankBalance" select="$BankBalance"/>
                        <xsl:with-param name="Prefix">BankBalance</xsl:with-param>
                      </xsl:call-template>

                    </div>
                  </div>
                </xsl:if>
                <xsl:if test="boolean(//PageVars/IsDashboard) = false()">
                  <xsl:call-template name="StatementBalance">
                    <xsl:with-param name="BankBalance" select="$BankBalance"/>
                  </xsl:call-template>
                  <xsl:call-template name="LastImport"/>

                  <xsl:call-template name="XeroBalance">
                    <xsl:with-param name="BankBalance" select="$BankBalance"/>
                    <xsl:with-param name="XeroBalance" select="$XeroBalance"/>
                  </xsl:call-template>
                  <xsl:call-template name="BankReconciled">
                    <xsl:with-param name="BankBalance" select="$BankBalance"/>
                    <xsl:with-param name="XeroBalance" select="$XeroBalance"/>
                  </xsl:call-template>

                  <xsl:if test="CurrentStatement/ImportedDateTimeUTC != '' and StatementLinesToReconcile > 0 and $role != 'readonly'">
                    <div class="no-padding-top" style="margin-bottom:5px;">
                      <xsl:if test="$role = 'onramp'">
                        <a class="xbtn blue" href="/Bank/BankRecComments.aspx?accountID={AccountID}">
                          <xsl:text>Add comments &#8250;</xsl:text>
                        </a>
                      </xsl:if>
                      <xsl:if test="$role != 'onramp'">
                        <a class="xbtn blue" href="/Bank/BankRec.aspx?accountID={AccountID}">
                          <xsl:text>Reconcile </xsl:text>
                          <span id="itemsToRecCount">
                            <xsl:value-of select="StatementLinesToReconcile"/>
                          </span>
                          <xsl:text> item</xsl:text>
                          <xsl:if test="StatementLinesToReconcile > 1">s</xsl:if>
                        </a>
                      </xsl:if>
                    </div>
                  </xsl:if>
                </xsl:if>
              </div>
              <xsl:choose>
                <!-- managed client and readonly always see the graphs -->
                <xsl:when test="($role = 'readonly' or $role = 'onramp') and boolean(//PageVars/IsDashboard)">
                  <div class="flash" style="height:125px;width:460px;">
                    <div id="chartCanvas_{CleanAccountID}" align="center" class="chart small"></div>
                    <script type="text/javascript">
                      XERO.widget.chart.RenderXeroChart("<xsl:value-of select="CleanAccountID" />", 460, 125, { reportType: "ShortCashFlowReport", bankAccountID: "<xsl:value-of select="AccountID" />" });
                    </script>
                    <!--<xsl:value-of disable-output-escaping="yes" select="Page:RenderXeroChart(concat('ShortCashFlowReport&amp;bankAccountID=', AccountID), CleanAccountID, 280, 145)"/>-->
                  </div>
                </xsl:when>
                <xsl:when test="($role = 'readonly' or $role = 'onramp') and boolean(//PageVars/IsDashboard) = false()">
                  <div class="flash">
                    <div id="chartCanvas_{CleanAccountID}" align="center" class="chart"></div>
                    <script type="text/javascript">
                      XERO.widget.chart.RenderXeroChart("<xsl:value-of select="CleanAccountID" />", 755, 135, { reportType: "CashFlowReport", bankAccountID: "<xsl:value-of select="AccountID" />" });
                    </script>
                    <!--<xsl:value-of disable-output-escaping="yes" select="Page:RenderXeroChart(concat('CashFlowReport&amp;bankAccountID=', AccountID), CleanAccountID, 755, 135)"/>-->
                  </div>
                </xsl:when>
                <!-- other roles can see the messages -->

                <xsl:when test="$has-transactions = 'false' and $new-and-eligible-partner = 'true'">
                  <xsl:call-template name="new-and-eligible-partner">
                    <xsl:with-param name="partner-href" select="$partner-url"/>
                    <xsl:with-param name="hookup" select="$hookup"/>
                    <xsl:with-param name="is-banking-down" select="$is-banking-down"/>
                    <xsl:with-param name="is-migrating" select="$is-migrating"/>
                    <xsl:with-param name="is-migrating-href" select="$is-migrating-href"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$has-transactions = 'false' and ($new-and-eligible = 'true' or $canConnect = 'true')">
                  <xsl:call-template name="new-and-eligible">
                    <xsl:with-param name="has-hookup" select="$has-hookup"/>
                    <xsl:with-param name="org-type" select="$org-type"/>
                    <xsl:with-param name="is-banking-down" select="$is-banking-down"/>
                    <xsl:with-param name="is-generic" select="$is-generic-hookup"/>
                    <xsl:with-param name="financial-connect-url" select="$financial-connect-start-url"/>
                    <xsl:with-param name="is-migrating" select="$is-migrating"/>
                    <xsl:with-param name="is-migrating-href" select="$is-migrating-href"/>
                    <xsl:with-param name="hookup" select="$hookup"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$connecting-feed = 'true'">
                  <xsl:call-template name="connecting-feed"/>
                </xsl:when>
                <xsl:when test="$has-transactions = 'false' and $connected-feed = 'true'">
                  <xsl:call-template name="connected-feed"/>
                </xsl:when>
                <xsl:when test="$needs-authorization = 'true'">
                  <xsl:call-template name="needs-authorization">
                    <xsl:with-param name="hookup" select="$hookup"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$loading-feed = 'true'">
                  <xsl:call-template name="loading-feed"/>
                </xsl:when>
                <xsl:when test="$no-transactions-imported = 'true'">
                  <xsl:call-template name="no-transactions-imported"/>
                </xsl:when>
                <xsl:when test="boolean(//PageVars/IsDashboard)">
                  <div class="flash" style="height:125px;width:460px;">
                    <div id="chartCanvas_{CleanAccountID}" align="center" class="chart small"></div>
                    <script type="text/javascript">
                      XERO.widget.chart.RenderXeroChart("<xsl:value-of select="CleanAccountID" />", 460, 125, { reportType: "ShortCashFlowReport", bankAccountID: "<xsl:value-of select="AccountID" />" });
                    </script>
                    <!--<xsl:value-of disable-output-escaping="yes" select="Page:RenderXeroChart(concat('ShortCashFlowReport&amp;bankAccountID=', AccountID), CleanAccountID, 280, 145)"/>-->
                  </div>
                </xsl:when>
                <xsl:when test="boolean(//PageVars/IsDashboard) = false()">
                  <div class="flash">
                    <div id="chartCanvas_{CleanAccountID}" align="center" class="chart"></div>
                    <script type="text/javascript">
                      XERO.widget.chart.RenderXeroChart("<xsl:value-of select="CleanAccountID" />", 755, 135, { reportType: "CashFlowReport", bankAccountID: "<xsl:value-of select="AccountID" />" });
                    </script>
                    <!--<xsl:value-of disable-output-escaping="yes" select="Page:RenderXeroChart(concat('CashFlowReport&amp;bankAccountID=', AccountID), CleanAccountID, 755, 135)"/>-->
                  </div>
                </xsl:when>
              </xsl:choose>

            </div>
			  <xsl:call-template name="refresh-feeds-button">
                <xsl:with-param name="is-beta" select="$is-beta"/>
                <xsl:with-param name="hookup" select="$hookup" />
                <xsl:with-param name="has-feed-errors" select="$has-feed-errors"/>
                <xsl:with-param name="hookup-isrefreshing" select="$hookup-isrefreshing"/>
                <xsl:with-param name="is-processing" select="$is-processing"/>
                <xsl:with-param name="mfa-can-refresh" select="$mfa-can-refresh"/>
                <xsl:with-param name="accountID" select="AccountID"/>
                <xsl:with-param name="hookupID" select="$hookupID"/>
                <xsl:with-param name="is-mfa-feed" select="$is-mfa-feed"/>
                <xsl:with-param name="createdByName" select="$hookup/CreatedByName"/>
                <xsl:with-param name="show-refresh-button" select="$show-refresh-button"/>
              </xsl:call-template>

              <xsl:if test="$sortable = 'true' and $role != 'readonly'">
                  <div class="sortable">

                <div class="right">
                  <div class="field">
                    <div>
                      <input type="checkbox" value="{AccountID}" id="bank_{position()}" autocomplete="off">
                        <xsl:if test="$dashboard = 'true'">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                      </input>
                    </div>
                    <label for="bank_{position()}">
                      <xsl:text>Show account on Dashboard</xsl:text>
                    </label>
                  </div>
                  <div class="order">
                    <label>
                      <xsl:text>Change order</xsl:text>
                    </label>
                    <xsl:call-template name="v2-link">
                      <xsl:with-param name="color">skip</xsl:with-param>
                      <xsl:with-param name="icon">move-up</xsl:with-param>
                      <xsl:with-param name="text">&nbsp;</xsl:with-param>
                      <xsl:with-param name="size">thin</xsl:with-param>
                      <xsl:with-param name="href">javascript:</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="v2-link">
                      <xsl:with-param name="color">skip</xsl:with-param>
                      <xsl:with-param name="icon">move-down</xsl:with-param>
                      <xsl:with-param name="text">&nbsp;</xsl:with-param>
                      <xsl:with-param name="size">thin</xsl:with-param>
                      <xsl:with-param name="href">javascript:</xsl:with-param>
                    </xsl:call-template>
                  </div>
                </div>
              </div>
            </xsl:if>

            <xsl:if test="$has-transactions = 'true' and $has-feed-errors != 'true' and $role != 'onramp' and $role != 'readonly'">
              <xsl:choose>
                <xsl:when test="$new-and-eligible-partner = 'true'">
                  <xsl:call-template name="new-and-eligible-partner">
                    <xsl:with-param name="footer">true</xsl:with-param>
                    <xsl:with-param name="partner-href" select="$partner-url"/>
                    <xsl:with-param name="hookup" select="$hookup"/>
                    <xsl:with-param name="is-banking-down" select="$is-banking-down"/>
                    <xsl:with-param name="is-migrating" select="$is-migrating"/>
                    <xsl:with-param name="is-migrating-href" select="$is-migrating-href"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$new-and-eligible = 'true' or $canConnect = 'true'">
                  <xsl:call-template name="new-and-eligible">
                    <xsl:with-param name="footer">true</xsl:with-param>
                    <xsl:with-param name="has-hookup" select="$has-hookup"/>
                    <xsl:with-param name="org-type" select="$org-type"/>
                    <xsl:with-param name="is-banking-down" select="$is-banking-down"/>
                    <xsl:with-param name="is-generic" select="$is-generic-hookup"/>
                    <xsl:with-param name="financial-connect-url" select="$financial-connect-start-url"/>
                    <xsl:with-param name="is-migrating" select="$is-migrating"/>
                    <xsl:with-param name="is-migrating-href" select="$is-migrating-href"/>
                    <xsl:with-param name="hookup" select="$hookup"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$connected-feed = 'true'">
                  <xsl:call-template name="connected-feed">
                    <xsl:with-param name="footer">true</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
              </xsl:choose>
            </xsl:if>

						<xsl:if test="//OrganisationLimitCounts/ReconciledStatementLinesLimit != '' and //OrganisationLimitCounts/ReconciledBankTransactionCount > 0 and /Message/Response/Organisation/IsInTrial = 'False'">

							<xsl:variable name="ReconciledCount" select="//OrganisationLimitCounts/ReconciledBankTransactionCount"/>
							<xsl:variable name="ReconciledLimit" select="//OrganisationLimitCounts/ReconciledStatementLinesLimit"/>
							<xsl:variable name="IsInTrial" select="/Message/Response/Organisation/IsInTrial"/>

							<div class="starter-limit">
								<div>
									<xsl:value-of select="$ReconciledCount"/>
									<xsl:text> of </xsl:text>
									<xsl:value-of select="$ReconciledLimit"/>
									<xsl:text> statement lines reconciled this month</xsl:text>
								</div>
								<xsl:if test="$ReconciledCount = $ReconciledLimit">
									<a style="float:right;" href="{//MyXeroPricingPlan}">Upgrade now</a>
								</xsl:if>
							</div>
						</xsl:if>

					  <div class="dashboard-box-mask"></div>
            <xsl:if test="boolean(//PageVars/IsDashboard) and boolean(//PageVars/IsOldDashboard) = false()">
              <script type="text/javascript">
                Ext.onReady(function() {
                  var list = Ext.query("div[data-type=bank-<xsl:value-of select="CleanAccountID"/>]").first();
                  //XERO.widget.Menus.cache.add(list.id || XERO.widget.Menus.cache.length + 1, new XERO.widget.Menu(list));
                });
              </script>
            </xsl:if>
          </div>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="bank-summary">

          <xsl:call-template name="BankLogo">
            <xsl:with-param name="bank" select="$bank"/>
            <xsl:with-param name="logoUrl" select="$hookup/LogoUrl" />
          </xsl:call-template>

          <xsl:if test="/Message/Response/Page/@Name != 'FastCoding'">
            <div class="balance">
              <xsl:call-template name="StatementBalance">
                <xsl:with-param name="BankBalance" select="$BankBalance"/>
              </xsl:call-template>
              <xsl:call-template name="XeroBalance">
                <xsl:with-param name="BankBalance" select="$BankBalance"/>
                <xsl:with-param name="XeroBalance" select="$XeroBalance"/>
              </xsl:call-template>
              <xsl:call-template name="BankReconciled">
                <xsl:with-param name="BankBalance" select="$BankBalance"/>
                <xsl:with-param name="XeroBalance" select="$XeroBalance"/>
              </xsl:call-template>
            </div>
          </xsl:if>

          <xsl:if test="
										$role != 'onramp' and
										$role != 'readonly'">
            <xsl:copy-of select="$menu"/>
          </xsl:if>

          <xsl:call-template name="refresh-feeds-button">
            <xsl:with-param name="hookup" select="$hookup" />
            <xsl:with-param name="has-feed-errors" select="$has-feed-errors"/>
            <xsl:with-param name="hookup-isrefreshing" select="$hookup-isrefreshing"/>
            <xsl:with-param name="is-processing" select="$is-processing"/>
            <xsl:with-param name="mfa-can-refresh" select="$mfa-can-refresh"/>
            <xsl:with-param name="accountID" select="AccountID"/>
            <xsl:with-param name="hookupID" select="$hookupID"/>
            <xsl:with-param name="is-mfa-feed" select="$is-mfa-feed"/>
            <xsl:with-param name="createdByName" select="$hookup/CreatedByName"/>
            <xsl:with-param name="show-refresh-button" select="$show-refresh-button"/>
          </xsl:call-template>

          <div class="last-import">
            <xsl:call-template name="LastImport"/>
            <xsl:choose>
              <xsl:when test="CurrentStatement/EndDate != ''">
                <a>
                  <xsl:attribute name="href">
                    <xsl:text>/Reports/report</xsl:text>
                    <xsl:if test="$role = 'accountant'">2</xsl:if>
                    <xsl:text>.aspx?statement=AE21E0AE-C1B1-4450-A99F-89F13258F6A8&amp;bankAccountID=</xsl:text>
                    <xsl:value-of select="AccountID"/>
                  </xsl:attribute>
                  <xsl:text>Reconciliation Report</xsl:text>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="
													$role != 'readonly' and
													$role != 'onramp'">
                  <a href="/Bank/Import.aspx?accountID={AccountID}" class="manual">
                    <xsl:text>Manually import a statement</xsl:text>
                  </a>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </div>

        <xsl:call-template name="og-v2">
          <xsl:with-param name="ID">OG_Glossary_BankDetailsSummary</xsl:with-param>
        </xsl:call-template>

        <xsl:if test="
												$role != 'readonly' and
												$role != 'onramp'">
          <xsl:choose>
            <xsl:when test="$show-errors = 'true'">
              <xsl:choose>
                <xsl:when test="$is-beta = 'true'">
                  <xsl:call-template name="feed-errors-beta">
                    <xsl:with-param name="header">true</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$bank = 'paypal'">
                  <xsl:call-template name="feed-errors-paypal">
                    <xsl:with-param name="header">true</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="feed-errors">
                    <xsl:with-param name="header">true</xsl:with-param>
                    <xsl:with-param name="bank-name" select="$hookup/BankName"/>
                    <xsl:with-param name="last-refresh-status" select="$hookup-last-refresh-status"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="$new-and-eligible-partner = 'true'">
              <xsl:call-template name="new-and-eligible-partner">
                <xsl:with-param name="header">true</xsl:with-param>
                <xsl:with-param name="partner-href" select="$partner-url"/>
                <xsl:with-param name="hookup" select="$hookup"/>
                <xsl:with-param name="is-banking-down" select="$is-banking-down"/>
                <xsl:with-param name="is-migrating" select="$is-migrating"/>
                <xsl:with-param name="is-migrating-href" select="$is-migrating-href"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$new-and-eligible = 'true' or $canConnect = 'true'">
              <xsl:call-template name="new-and-eligible">
                <xsl:with-param name="header">true</xsl:with-param>
                <xsl:with-param name="has-hookup" select="$has-hookup"/>
                <xsl:with-param name="org-type" select="$org-type"/>
                <xsl:with-param name="is-banking-down" select="$is-banking-down"/>
                <xsl:with-param name="is-generic" select="$is-generic-hookup"/>
                <xsl:with-param name="financial-connect-url" select="$financial-connect-start-url"/>
                <xsl:with-param name="is-migrating" select="$is-migrating"/>
                <xsl:with-param name="is-migrating-href" select="$is-migrating-href"/>
                <xsl:with-param name="hookup" select="$hookup"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$connecting-feed = 'true'">
              <xsl:call-template name="connecting-feed">
                <xsl:with-param name="header">true</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$connected-feed = 'true'">
              <xsl:call-template name="connected-feed">
                <xsl:with-param name="header">true</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$needs-authorization = 'true'">
              <xsl:call-template name="needs-authorization">
                <xsl:with-param name="header">true</xsl:with-param>
                <xsl:with-param name="hookup" select="$hookup"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$loading-feed = 'true'">
              <xsl:call-template name="loading-feed">
                <xsl:with-param name="header">true</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$no-transactions-imported = 'true'">
              <xsl:call-template name="no-transactions-imported">
                <xsl:with-param name="header">true</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="refresh-feeds-button">
    <xsl:param name="is-beta"/>
    <xsl:param name="hookup"/>
    <xsl:param name="has-feed-errors"/>
    <xsl:param name="hookup-isrefreshing"/>
    <xsl:param name="is-processing"/>
    <xsl:param name="mfa-can-refresh"/>
    <xsl:param name="accountID"/>
    <xsl:param name="hookupID"/>
    <xsl:param name="is-mfa-feed"/>
    <xsl:param name="createdByName"/>
    <xsl:param name="show-refresh-button"/>

    <!-- We don't want the bank pages (BankTransactions.aspx, Statements.aspx, BankRec.aspx, FastCoding.aspx) to display the refresh
                                            button in the header but we do want to show them the message saying who can refresh the feed (if the logged in user cannot).
                                            So when these pages call this template, we need to pass false into this parameter. -->

    <xsl:variable name="is-migrating">
        <xsl:choose>
            <xsl:when test="$hookup/IsMigratingToDirect = 'true'">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:if test="not($is-migrating = 'true' and $hookup/IsFormPrePop = 'true') and $hookup/IsActivated = 'true' and $has-feed-errors = 'false' and $hookup-isrefreshing = 'false'  and $is-processing = 'false' and $is-beta = 'false'">
      <xsl:choose>
        <xsl:when test="($hookup/IsMFA = 'true' and $mfa-can-refresh = 'true')">
          <xsl:if test="$show-refresh-button = 'true' and not(Page:UserIsInRole($Roles.ReadOnly))">
            <div class="imports">
              <xsl:if test="boolean(//PageVars/IsDashboard)">
                <div class="refresh-feeds">Your bank may require additional steps to update this feed. </div>
                <a href="javascript:" class="refresh-feed-link" onclick="ChartOfAccounts.refreshBankFeed('{AccountID}', '{$hookupID}', {$is-mfa-feed})">Refresh feed</a>
              </xsl:if>
              <xsl:if test="boolean(//PageVars/IsDashboard) = false()">
                <a href="javascript:" class="xbtn blue" onclick="ChartOfAccounts.refreshBankFeed('{AccountID}', '{$hookupID}', {$is-mfa-feed})">Refresh Feed</a>
                <xsl:text>Your bank may require additional steps to update this feed </xsl:text>
              </xsl:if>
            </div>
          </xsl:if>
          <!--ELSE SHOW NOTHING-->
        </xsl:when>
        <xsl:when test="($hookup/IsMFA = 'true' and $mfa-can-refresh = 'false' and $is-beta = 'false')">
          <div class="imports">
            Only <xsl:value-of select="$hookup/CreatedByName"/> can refresh this bank feed
            <xsl:if test="boolean(//PageVars/IsDashboard) = false()">
              <xsl:call-template name="og-fixed-v2">
                <xsl:with-param name="id">OG_Glossary_YodleeRefresh</xsl:with-param>
                <xsl:with-param name="style">width:0px;height:18px;position:absolute;</xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </div>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>
