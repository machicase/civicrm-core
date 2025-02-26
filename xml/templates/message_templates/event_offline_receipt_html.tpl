<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
 <title></title>
</head>
<body>

{capture assign=headerStyle}colspan="2" style="text-align: left; padding: 4px; border-bottom: 1px solid #999; background-color: #eee;"{/capture}
{capture assign=labelStyle}style="padding: 4px; border-bottom: 1px solid #999; background-color: #f7f7f7;"{/capture}
{capture assign=valueStyle}style="padding: 4px; border-bottom: 1px solid #999;"{/capture}

  <table id="crm-event_receipt" style="font-family: Arial, Verdana, sans-serif; text-align: left; width:100%; max-width:700px; padding:0; margin:0; border:0px;">

  <!-- BEGIN HEADER -->
  <!-- You can add table row(s) here with logo or other header elements -->
  <!-- END HEADER -->

  <!-- BEGIN CONTENT -->

  <tr>
   <td>
    {assign var="greeting" value="{contact.email_greeting_display}"}{if $greeting}<p>{$greeting},</p>{/if}

    {if !empty($event.confirm_email_text) AND (empty($isOnWaitlist) AND empty($isRequireApproval))}
     <p>{$event.confirm_email_text}</p>
    {/if}

    {if !empty($isOnWaitlist)}
      <p>{ts}You have been added to the WAIT LIST for this event.{/ts}</p>
      <p>{ts}If space becomes available you will receive an email with a link to a web page where you can complete your registration.{/ts}</p>
    {elseif !empty($isRequireApproval)}
      <p>{ts}Your registration has been submitted.{/ts}</p>
      <p>{ts}Once your registration has been reviewed, you will receive an email with a link to a web page where you can complete the registration process.{/ts}</p>
    {elseif $is_pay_later}
     <p>{$pay_later_receipt}</p> {* FIXME: this might be text rather than HTML *}
    {/if}

   </td>
  </tr>
  <tr>
   <td>
    <table style="border: 1px solid #999; margin: 1em 0em 1em; border-collapse: collapse; width:100%;">
     <tr>
      <th {$headerStyle}>
       {ts}Event Information and Location{/ts}
      </th>
     </tr>
     <tr>
      <td colspan="2" {$valueStyle}>
       {event.title}<br />
       {event.start_date|crmDate}{if {event.end_date|boolean}}-{if '{event.end_date|crmDate:"%Y%m%d"}' === '{event.start_date|crmDate:"%Y%m%d"}'}{event.end_date|crmDate:"Time"}{else}{event.end_date}{/if}{/if}
      </td>
     </tr>

     {if "{participant.role_id:label}" neq 'Attendee'}
      <tr>
       <td {$labelStyle}>
        {ts}Participant Role{/ts}
       </td>
       <td {$valueStyle}>
         {participant.role_id:label}
       </td>
      </tr>
     {/if}

     {if {event.is_show_location|boolean}}
      <tr>
       <td colspan="2" {$valueStyle}>
         {event.location}
       </td>
      </tr>
     {/if}

     {if {event.loc_block_id.phone_id.phone|boolean} || {event.loc_block_id.email_id.email|boolean}}
      <tr>
       <td colspan="2" {$labelStyle}>
        {ts}Event Contacts:{/ts}
       </td>
      </tr>

       {if {event.loc_block_id.phone_id.phone|boolean}}
        <tr>
         <td {$labelStyle}>
          {if {event.loc_block_id.phone_id.phone_type_id|boolean}}
            {event.loc_block_id.phone_id.phone_type_id:label}
          {else}
           {ts}Phone{/ts}
          {/if}
         </td>
         <td {$valueStyle}>
          {event.loc_block_id.phone_id.phone} {if {event.loc_block_id.phone_id.phone_ext|boolean}}&nbsp;{ts}ext.{/ts} {event.loc_block_id.phone_id.phone_ext}{/if}
         </td>
        </tr>
       {/if}
         {if {event.loc_block_id.phone_2_id.phone|boolean}}
           <tr>
             <td {$labelStyle}>
                 {if {event.loc_block_id.phone_2_id.phone_type_id|boolean}}
                     {event.loc_block_id.phone_2_id.phone_type_id:label}
                 {else}
                     {ts}Phone{/ts}
                 {/if}
             </td>
             <td {$valueStyle}>
                 {event.loc_block_id.phone_2_id.phone} {if {event.loc_block_id.phone_2_id.phone_ext|boolean}}&nbsp;{ts}ext.{/ts} {event.loc_block_id.phone_2_id.phone_ext}{/if}
             </td>
           </tr>
         {/if}


       {if {event.loc_block_id.email_id.email|boolean}}
        <tr>
         <td {$labelStyle}>
          {ts}Email{/ts}
         </td>
         <td {$valueStyle}>
             {event.loc_block_id.email_id.email}
         </td>
        </tr>
       {/if}

       {if {event.loc_block_id.email_2_id.email|boolean}}
         <tr>
           <td {$labelStyle}>
               {ts}Email{/ts}
           </td>
           <td {$valueStyle}>
               {event.loc_block_id.email_2_id.email}
           </td>
         </tr>
       {/if}

     {/if}

     {if {event.is_public|boolean}}
      <tr>
       <td colspan="2" {$valueStyle}>
        {capture assign=icalFeed}{crmURL p='civicrm/event/ical' q="reset=1&id={event.id}" h=0 a=1 fe=1}{/capture}
        <a href="{$icalFeed}">{ts}Download iCalendar entry for this event.{/ts}</a>
       </td>
      </tr>
      <tr>
       <td colspan="2" {$valueStyle}>
        {capture assign=gCalendar}{crmURL p='civicrm/event/ical' q="gCalendar=1&reset=1&id={event.id}" h=0 a=1 fe=1}{/capture}
         <a href="{$gCalendar}">{ts}Add event to Google Calendar{/ts}</a>
       </td>
      </tr>
     {/if}

     {if {contact.email_primary.email|boolean}}
      <tr>
       <th {$headerStyle}>
        {ts}Registered Email{/ts}
       </th>
      </tr>
      <tr>
       <td colspan="2" {$valueStyle}>
         {contact.email_primary.email}
       </td>
      </tr>
     {/if}


     {if {event.is_monetary|boolean}}

      <tr>
       <th {$headerStyle}>
        {event.fee_label}
       </th>
      </tr>

      {if !empty($lineItem)}
       {foreach from=$lineItem item=value key=priceset}
        {if $value neq 'skip'}
          {if $lineItem|@count GT 1} {* Header for multi participant registration cases. *}
           <tr>
            <td colspan="2" {$labelStyle}>
             {ts 1=$priceset+1}Participant %1{/ts}
            </td>
           </tr>
          {/if}

         <tr>
          <td colspan="2" {$valueStyle}>
           <table>
            <tr>
             <th>{ts}Item{/ts}</th>
             <th>{ts}Qty{/ts}</th>
             <th>{ts}Each{/ts}</th>
             {if $isShowTax && {contribution.tax_amount|boolean}}
              <th>{ts}SubTotal{/ts}</th>
              <th>{ts}Tax Rate{/ts}</th>
              <th>{ts}Tax Amount{/ts}</th>
             {/if}
             <th>{ts}Total{/ts}</th>
       {if !empty($pricesetFieldsCount)}<th>{ts}Total Participants{/ts}</th>{/if}
            </tr>
            {foreach from=$value item=line}
             <tr>
              <td>
        {if $line.html_type eq 'Text'}{$line.label}{else}{$line.field_title} - {$line.label}{/if} {if $line.description}<div>{$line.description|truncate:30:"..."}</div>{/if}
              </td>
              <td>
               {$line.qty}
              </td>
              <td>
               {$line.unit_price|crmMoney}
              </td>
              {if !empty($dataArray)}
               <td>
                {$line.unit_price*$line.qty|crmMoney}
               </td>
               {if $line.tax_rate || $line.tax_amount != ""}
                <td>
                 {$line.tax_rate|string_format:"%.2f"}%
                </td>
                <td>
                 {$line.tax_amount|crmMoney}
                </td>
               {else}
                <td></td>
                <td></td>
               {/if}
              {/if}
              <td>
               {$line.line_total+$line.tax_amount|crmMoney}
              </td>
        {if !empty($pricesetFieldsCount)}
        <td>
    {$line.participant_count}
              </td>
        {/if}
             </tr>
            {/foreach}
           </table>
          </td>
         </tr>
        {/if}
       {/foreach}
       {if !empty($dataArray)}
        {if $totalAmount and $totalTaxAmount}
        <tr>
         <td {$labelStyle}>
          {ts}Amount Before Tax:{/ts}
         </td>
         <td {$valueStyle}>
          {$totalAmount-$totalTaxAmount|crmMoney}
         </td>
        </tr>
        {/if}
        {foreach from=$dataArray item=value key=priceset}
          <tr>
           {if $priceset || $priceset == 0}
            <td>&nbsp;{$taxTerm} {$priceset|string_format:"%.2f"}%</td>
            <td>&nbsp;{$value|crmMoney:$currency}</td>
           {/if}
          </tr>
        {/foreach}
       {/if}
      {/if}

      {if !empty($amount) && !$lineItem}
       {foreach from=$amount item=amnt key=level}
        <tr>
         <td colspan="2" {$valueStyle}>
          {$amnt.amount|crmMoney} {$amnt.label}
         </td>
        </tr>
       {/foreach}
      {/if}
      {if {contribution.tax_amount|boolean}}
       <tr>
        <td {$labelStyle}>
         {ts}Total Tax Amount{/ts}
        </td>
        <td {$valueStyle}>
          {contribution.tax_amount}
        </td>
       </tr>
      {/if}
      {if {event.is_monetary|boolean}}
       {if {contribution.balance_amount|boolean}}
         <tr>
           <td {$labelStyle}>{ts}Total Paid{/ts}</td>
           <td {$valueStyle}>
             {contribution.paid_amount} {if !empty($hookDiscount.message)}({$hookDiscount.message}){/if}
           </td>
          </tr>
          <tr>
           <td {$labelStyle}>{ts}Balance{/ts}</td>
           <td {$valueStyle}>{contribution.balance_amount}</td>
         </tr>
        {else}
         <tr>
           <td {$labelStyle}>{ts}Total Amount{/ts}</td>
           <td {$valueStyle}>
             {contribution.total_amount} {if !empty($hookDiscount.message)}({$hookDiscount.message}){/if}
           </td>
         </tr>
       {/if}
       {if !empty($pricesetFieldsCount)}
     <tr>
       <td {$labelStyle}>
   {ts}Total Participants{/ts}</td>
       <td {$valueStyle}>
   {assign var="count" value= 0}
         {foreach from=$lineItem item=pcount}
         {assign var="lineItemCount" value=0}
         {if $pcount neq 'skip'}
           {foreach from=$pcount item=p_count}
           {assign var="lineItemCount" value=$lineItemCount+$p_count.participant_count}
           {/foreach}
           {if $lineItemCount < 1}
           assign var="lineItemCount" value=1}
           {/if}
           {assign var="count" value=$count+$lineItemCount}
         {/if}
         {/foreach}
   {$count}
       </td>
     </tr>
     {/if}
     {if {contribution.is_pay_later|boolean} && {contribution.balance_amount|boolean}}
        <tr>
         <td colspan="2" {$labelStyle}>
          {$pay_later_receipt}
         </td>
        </tr>
       {/if}

       {if {participant.register_date|boolean}}
        <tr>
         <td {$labelStyle}>
          {ts}Registration Date{/ts}
         </td>
         <td {$valueStyle}>
           {participant.register_date}
         </td>
        </tr>
       {/if}

       {if {contribution.receive_date|boolean}}
        <tr>
         <td {$labelStyle}>
          {ts}Transaction Date{/ts}
         </td>
         <td {$valueStyle}>
           {contribution.receive_date}
         </td>
        </tr>
       {/if}

       {if {contribution.financial_type_id|boolean}}
        <tr>
         <td {$labelStyle}>
          {ts}Financial Type{/ts}
         </td>
         <td {$valueStyle}>
           {contribution.financial_type_id:label}
         </td>
        </tr>
       {/if}

       {if {contribution.financial_trxn_id|boolean}}
        <tr>
         <td {$labelStyle}>
          {ts}Transaction #{/ts}
         </td>
         <td {$valueStyle}>
           {contribution.financial_trxn_id}
         </td>
        </tr>
       {/if}

       {if {contribution.payment_instrument_id|boolean}}
        <tr>
         <td {$labelStyle}>
          {ts}Paid By{/ts}
         </td>
         <td {$valueStyle}>
           {contribution.payment_instrument_id:label}
         </td>
        </tr>
       {/if}

       {if {contribution.check_number|boolean}}
        <tr>
         <td {$labelStyle}>
          {ts}Check Number{/ts}
         </td>
         <td {$valueStyle}>
           {contribution.check_number}
         </td>
        </tr>
       {/if}

       {if !empty($billingName)}
        <tr>
         <th {$headerStyle}>
          {ts}Billing Name and Address{/ts}
         </th>
        </tr>
        <tr>
         <td colspan="2" {$valueStyle}>
          {$billingName}<br />
          {$address|nl2br}
         </td>
        </tr>
       {/if}

       {if !empty($credit_card_type)}
        <tr>
         <th {$headerStyle}>
          {ts}Credit Card Information{/ts}
         </th>
        </tr>
        <tr>
         <td colspan="2" {$valueStyle}>
          {$credit_card_type}<br />
          {$credit_card_number}<br />
          {ts}Expires{/ts}: {$credit_card_exp_date|truncate:7:''|crmDate}
         </td>
        </tr>
       {/if}

      {/if}

     {/if} {* End of conditional section for Paid events *}

     {if !empty($customGroup)}
      {foreach from=$customGroup item=value key=customName}
       <tr>
        <th {$headerStyle}>
         {$customName}
        </th>
       </tr>
       {foreach from=$value item=v key=n}
        <tr>
         <td {$labelStyle}>
          {$n}
         </td>
         <td {$valueStyle}>
          {$v}
         </td>
        </tr>
       {/foreach}
      {/foreach}
     {/if}

    </table>
   </td>
  </tr>

 </table>

</body>
</html>
