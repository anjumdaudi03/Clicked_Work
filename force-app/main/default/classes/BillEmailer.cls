public with sharing class BillEmailer {
    
    public static void sendEmails(Map<String, Blob> emailsWithBills) {
        //instantiate a list of Messaging.SingleEmailMessage objects
        //Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
// Set recipients to two contact IDs.
// Replace IDs with valid record IDs in your org.
 
		List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        //iterate over the keyset of the emailsWithBills map and instantiate a single Messaging.SingleEmailMessage
        //object. Set the bccAddress to the email from the iteration, set a PlainTextBody, and set a Subject for the
        //Messaging.SingleEmailMessage object.

        for(String email : emailsWithBills.keySet()) {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

        	message.toAddresses = new String[] { '003Hp00002oNn99IAC', '003Hp00002oNn9GIAS' };
            message.subject = 'Your monthly bill';
            message.plainTextBody = 'Plaese find attatched your monthly usage bill.';
            message.bccAddresses = new String[] { email };
            //use the following
            //to attach the PDF blob to the email:
            ContentVersion cv = new ContentVersion();
            cv.VersionData = emailsWithBills.get(email);
            cv.Title = 'Contact Bill';
            cv.PathOnClient = 'contactBill.pdf';
            cv.Description = 'Bill sent to the contact';
            cv.isMajorVersion = true;
            insert cv;
			message.setEntityAttachments(new list<Id> {cv.Id});
            /*Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.Body = emailsWithBills.get(email);
            attach.FileName = 'Bill-' + Date.Today().Month() + '-' + Date.Today().Day() + '-' + Date.Today().Year() + '.pdf';
            attach.ContentType = 'application/pdf';

            message.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});*/

            //add the Messaging.SingleEmailMessage object to the list inside of the loop, and send the email outside of the loop.
			emailsToSend.add(message);
        }

        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailsToSend);
        // Call a helper method to inspect the returned results
        inspectResults(results);
    }

    //this is a method that will allow you to check to see if your code works.
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        // sendEmail returns an array of result objects.
        // Iterate through the list to inspect results. 
        // In this class, the methods send only one email, 
        // so we should have only one result.
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());                 
            }
        }
        return sendResult;
    }
}