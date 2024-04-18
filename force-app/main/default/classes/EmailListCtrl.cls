public with sharing class EmailListCtrl {
    public EmailListCtrl() {}

    @AuraEnabled(cacheable = true) public static List < EmailWrapper > incoming_Emails(String status, String subject,
        String fromAddress, String toAddress, Date fromDate, Date toDate, Boolean isAttachment, String selectdObj, Boolean isDeleted,
        String emailTags, String relatedTo, Boolean isActioned, Boolean isIncoming) {
        try {
            String emailSubject = '%' + subject + '%';
            String emailfrom = '%' + fromAddress + '%';
            String emailto = '%' + toAddress + '%';
            String relatedToName = '%' + relatedTo + '%';
            List < EmailMessage > emailList = new List < EmailMessage > ();
            List < String > tags = new List < String > ();
            if (String.isNotEmpty(emailTags)) {
                if (emailTags.contains(';')) {
                    if (String.isNotEmpty(emailTags)) {
                        for (String str: emailTags.split(';')) {
                            tags.add(str);
                        }
                    }
                }
            }

            if (isDeleted) {
                emailList = [SELECT Id,
                    Subject,
                    FromAddress,
                    ToAddress,
                    MessageDate,
                    RelatedToId,
                    RelatedTo.Name,
                    HasAttachment,
                    LastModifiedBy.Name,
                    LastModifiedDate,
                    P360_Email_Tags__c,
                    P360_Actioned__c,
                    Status FROM EmailMessage WHERE(Subject LIKE: emailSubject OR Subject =: subject)
                    AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                    AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                    AND MessageDate >=: fromDate AND MessageDate <=: toDate
                    AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                    AND(P360_Email_Tags__c INCLUDES(: emailTags) OR P360_Email_Tags__c =: tags)
                    AND P360_Actioned__c =: isActioned
                    AND isDeleted =: isDeleted ALL ROWS
                ];
            } else if (!isDeleted && status == '0') {

                if (!tags.isEmpty()) {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE(Status = '0'
                            OR Status = '1'
                            OR Status = '2')
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND Incoming =: isIncoming
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND(P360_Email_Tags__c INCLUDES(: emailTags) OR P360_Email_Tags__c =: tags)
                        AND P360_Actioned__c =: isActioned
                        Order By MessageDate DESC
                    ];
                } else if (String.isNotEmpty(emailTags)) {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE(Status = '0'
                            OR Status = '1'
                            OR Status = '2')
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND Incoming =: isIncoming
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND(P360_Email_Tags__c INCLUDES(: emailTags))
                        AND P360_Actioned__c =: isActioned
                        Order By MessageDate DESC
                    ];
                } else {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE(Status = '0'
                            OR Status = '1'
                            OR Status = '2')
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND Incoming =: isIncoming
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND P360_Actioned__c =: isActioned
                        Order By MessageDate DESC
                    ];
                }
            } else if (!isDeleted && status == '3') {
                if (!tags.isEmpty()) {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE(Status =: status OR Status = '2'
                            OR Status = '4')
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND Incoming = false
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND(P360_Email_Tags__c INCLUDES(: emailTags) OR P360_Email_Tags__c =: tags)
                        AND P360_Actioned__c =: isActioned
                        AND Incoming =: isIncoming
                        Order By MessageDate DESC
                    ];
                } else if (String.isNotEmpty(emailTags)) {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE(Status =: status OR Status = '2'
                            OR Status = '4')
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND Incoming = false
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND(P360_Email_Tags__c INCLUDES(: emailTags))
                        AND P360_Actioned__c =: isActioned
                        AND Incoming =: isIncoming
                        Order By MessageDate DESC
                    ];
                } else {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE(Status =: status OR Status = '2'
                            OR Status = '4')
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND Incoming = false
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND P360_Actioned__c =: isActioned
                        AND Incoming =: isIncoming
                        Order By MessageDate DESC
                    ];
                }

            } else if (!isDeleted && status == '5') {
                if (!tags.isEmpty()) {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE(Status =: status)
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND(P360_Email_Tags__c INCLUDES(: emailTags) OR P360_Email_Tags__c =: tags)
                        AND P360_Actioned__c =: isActioned
                        AND Incoming =: isIncoming
                        Order By MessageDate DESC
                    ];

                } else if (String.isNotEmpty(emailTags)) {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE(Status =: status)
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND(P360_Email_Tags__c INCLUDES(: emailTags))
                        AND P360_Actioned__c =: isActioned
                        AND Incoming =: isIncoming
                        Order By MessageDate DESC
                    ];
                } else {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE(Status =: status)
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND P360_Actioned__c =: isActioned
                        AND Incoming =: isIncoming
                        Order By MessageDate DESC
                    ];
                }
            } else if (!isDeleted && status == '2') {
                if (!tags.isEmpty()) {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE Status = '2'
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND(P360_Email_Tags__c INCLUDES(: emailTags) OR P360_Email_Tags__c =: tags)
                        AND P360_Actioned__c =: isActioned
                        AND Incoming =: isIncoming
                        Order By MessageDate DESC
                    ];
                } else if (String.isNotEmpty(emailTags)) {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE Status = '2'
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND(P360_Email_Tags__c INCLUDES(: emailTags))
                        AND P360_Actioned__c =: isActioned
                        AND Incoming =: isIncoming
                        Order By MessageDate DESC
                    ];
                } else {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE Status = '2'
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND P360_Actioned__c =: isActioned
                        AND Incoming =: isIncoming
                        Order By MessageDate DESC
                    ];
                }

            } else if (!isDeleted && status == '1') {
                if (!tags.isEmpty()) {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE Status = '1'
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND(P360_Email_Tags__c INCLUDES(: emailTags) OR P360_Email_Tags__c =: tags)
                        AND P360_Actioned__c =: isActioned
                        AND Incoming =: isIncoming
                        Order By MessageDate DESC
                    ];
                } else if (String.isNotEmpty(emailTags)) {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE Status = '1'
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND(P360_Email_Tags__c INCLUDES(: emailTags))
                        AND P360_Actioned__c =: isActioned
                        AND Incoming =: isIncoming
                        Order By MessageDate DESC
                    ];
                } else {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE Status = '1'
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND P360_Actioned__c =: isActioned
                        AND Incoming =: isIncoming
                        Order By MessageDate DESC
                    ];
                }

            } else if (!isDeleted && status == '4') {
                if (!tags.isEmpty()) {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE Status = '4'
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND(P360_Email_Tags__c INCLUDES(: emailTags) OR P360_Email_Tags__c =: tags)
                        AND P360_Actioned__c =: isActioned
                        AND Incoming =: isIncoming
                        Order By MessageDate DESC
                    ];
                } else if (String.isNotEmpty(emailTags)) {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE Status = '4'
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND(P360_Email_Tags__c INCLUDES(: emailTags))
                        AND P360_Actioned__c =: isActioned
                        AND Incoming =: isIncoming
                        Order By MessageDate DESC
                    ];
                } else {
                    emailList = [SELECT Id,
                        Subject,
                        FromAddress,
                        ToAddress,
                        MessageDate,
                        RelatedToId,
                        RelatedTo.Name,
                        HasAttachment,
                        LastModifiedBy.Name,
                        LastModifiedDate,
                        P360_Email_Tags__c,
                        P360_Actioned__c,
                        Status FROM EmailMessage WHERE Status = '4'
                        AND(Subject LIKE: emailSubject OR Subject =: subject)
                        AND(FromAddress LIKE: emailfrom OR FromAddress LIKE: fromAddress)
                        AND(ToAddress LIKE: emailto OR ToAddress LIKE: toAddress)
                        AND MessageDate >=: fromDate
                        AND MessageDate <=: toDate
                        AND isDeleted =: isDeleted
                        AND(RelatedTo.Name LIKE: relatedToName OR RelatedTo.Name =: relatedTo)
                        AND P360_Actioned__c =: isActioned
                        AND Incoming =: isIncoming
                        Order By MessageDate DESC
                    ];
                }

            }
            List < EmailWrapper > emialWrapper = new List < EmailWrapper > ();

            Map < String, String > objMap = new Map < String, String > ();
            Map < String, Schema.SObjectType > gd = Schema.getGlobalDescribe();
            for (Schema.SObjectType stype: gd.values()) {
                Schema.DescribeSObjectResult r = stype.getDescribe();
                objMap.put(r.getKeyPrefix(), r.getLabel());
            }

            for (EmailMessage eMail: emailList) {
                EmailWrapper eWrap = new EmailWrapper();
                if (isAttachment == eMail.HasAttachment && eMail.RelatedToId != NULL && !String.isEmpty(selectdObj) && String.valueOf(eMail.RelatedToId).substring(0, 3) == selectdObj) {
                    eWrap.Id = eMail.Id;
                    if (!String.isEmpty(eMail.Subject)) {
                        eWrap.Subject = eMail.Subject;
                    } else {
                        eWrap.Subject = eMail.Id;
                    }
                    if (!String.isEmpty(eMail.FromAddress)) {
                        eWrap.FromAddress = eMail.FromAddress;
                    } else {
                        eWrap.FromAddress = '';
                    }
                    if (!String.isEmpty(eMail.ToAddress)) {
                        eWrap.ToAddress = eMail.ToAddress;
                    } else {
                        eWrap.ToAddress = '';
                    }
                    if (eMail.status == '2') {
                        eWrap.replied = true;
                    } else {
                        eWrap.replied = false;
                    }
                    if (eMail.status == '4') {
                        eWrap.forwarded = true;
                    } else {
                        eWrap.forwarded = false;
                    }
                    if (eMail.RelatedToId != null) {
                        if (objMap.containskey(String.valueOf(eMail.RelatedToId).substring(0, 3))) {
                            eWrap.RelatedObject = objMap.get(String.valueOf(eMail.RelatedToId).substring(0, 3));
                            eWrap.RelatedToId = eMail.RelatedToId;
                        }
                    } else {
                        eWrap.RelatedObject = '';
                        eWrap.RelatedToId = '';
                    }
                    eWrap.status = eMail.status;
                    eWrap.MessageDate = eMail.MessageDate;
                    eWrap.RelatedTo = eMail.RelatedTo.Name;
                    eWrap.HasAttachment = eMail.HasAttachment;
                    eWrap.modifiedBy = eMail.LastModifiedBy.Name;
                    eWrap.modifiedDate = eMail.LastModifiedDate;
                    eWrap.Has_Attachment = String.valueOf(eMail.HasAttachment);
                    emialWrapper.add(eWrap);

                } else if (isAttachment == null && eMail.RelatedToId != NULL && !String.isEmpty(selectdObj) && String.valueOf(eMail.RelatedToId).substring(0, 3) == selectdObj) {
                    eWrap.Id = eMail.Id;
                    if (!String.isEmpty(eMail.Subject)) {
                        eWrap.Subject = eMail.Subject;
                    } else {
                        eWrap.Subject = eMail.Id;
                    }
                    if (!String.isEmpty(eMail.FromAddress)) {
                        eWrap.FromAddress = eMail.FromAddress;
                    } else {
                        eWrap.FromAddress = '';
                    }
                    if (!String.isEmpty(eMail.ToAddress)) {
                        eWrap.ToAddress = eMail.ToAddress;
                    } else {
                        eWrap.ToAddress = '';
                    }
                    if (eMail.status == '2') {
                        eWrap.replied = true;
                    } else {
                        eWrap.replied = false;
                    }
                    if (eMail.status == '4') {
                        eWrap.forwarded = true;
                    } else {
                        eWrap.forwarded = false;
                    }
                    if (eMail.RelatedToId != null) {
                        if (objMap.containskey(String.valueOf(eMail.RelatedToId).substring(0, 3))) {
                            eWrap.RelatedObject = objMap.get(String.valueOf(eMail.RelatedToId).substring(0, 3));
                            eWrap.RelatedToId = eMail.RelatedToId;
                        }
                    } else {
                        eWrap.RelatedObject = '';
                        eWrap.RelatedToId = '';
                    }
                    eWrap.status = eMail.status;
                    eWrap.MessageDate = eMail.MessageDate;
                    eWrap.RelatedTo = eMail.RelatedTo.Name;
                    eWrap.HasAttachment = eMail.HasAttachment;
                    eWrap.modifiedBy = eMail.LastModifiedBy.Name;
                    eWrap.modifiedDate = eMail.LastModifiedDate;
                    eWrap.Has_Attachment = String.valueOf(eMail.HasAttachment);
                    emialWrapper.add(eWrap);

                } else if (String.isEmpty(selectdObj) && isAttachment == null) {
                    eWrap.Id = eMail.Id;
                    if (!String.isEmpty(eMail.Subject)) {
                        eWrap.Subject = eMail.Subject;
                    } else {
                        eWrap.Subject = eMail.Id;
                    }
                    if (!String.isEmpty(eMail.FromAddress)) {
                        eWrap.FromAddress = eMail.FromAddress;
                    } else {
                        eWrap.FromAddress = '';
                    }
                    if (!String.isEmpty(eMail.ToAddress)) {
                        eWrap.ToAddress = eMail.ToAddress;
                    } else {
                        eWrap.ToAddress = '';
                    }
                    eWrap.MessageDate = eMail.MessageDate;
                    if (!String.isEmpty(eMail.RelatedTo.Name)) {
                        eWrap.RelatedTo = eMail.RelatedTo.Name;
                    } else {
                        eWrap.RelatedTo = '';
                    }
                    if (eMail.status == '2') {
                        eWrap.replied = true;
                    } else {
                        eWrap.replied = false;
                    }
                    if (eMail.status == '4') {
                        eWrap.forwarded = true;
                    } else {
                        eWrap.forwarded = false;
                    }
                    if (eMail.RelatedToId != null) {
                        if (objMap.containskey(String.valueOf(eMail.RelatedToId).substring(0, 3))) {
                            eWrap.RelatedObject = objMap.get(String.valueOf(eMail.RelatedToId).substring(0, 3));
                            eWrap.RelatedToId = eMail.RelatedToId;
                        }
                    } else {
                        eWrap.RelatedObject = '';
                        eWrap.RelatedToId = '';
                    }
                    eWrap.status = eMail.status;
                    eWrap.modifiedBy = eMail.LastModifiedBy.Name;
                    eWrap.modifiedDate = eMail.LastModifiedDate;
                    eWrap.HasAttachment = eMail.HasAttachment;
                    eWrap.Has_Attachment = String.valueOf(eMail.HasAttachment);
                    emialWrapper.add(eWrap);
                } else if (String.isEmpty(selectdObj) && isAttachment == eMail.HasAttachment) {
                    eWrap.Id = eMail.Id;
                    if (!String.isEmpty(eMail.Subject)) {
                        eWrap.Subject = eMail.Subject;
                    } else {
                        eWrap.Subject = eMail.Id;
                    }
                    if (!String.isEmpty(eMail.FromAddress)) {
                        eWrap.FromAddress = eMail.FromAddress;
                    } else {
                        eWrap.FromAddress = '';
                    }
                    if (!String.isEmpty(eMail.ToAddress)) {
                        eWrap.ToAddress = eMail.ToAddress;
                    } else {
                        eWrap.ToAddress = '';
                    }
                    if (eMail.status == '2') {
                        eWrap.replied = true;
                    } else {
                        eWrap.replied = false;
                    }
                    if (eMail.status == '4') {
                        eWrap.forwarded = true;
                    } else {
                        eWrap.forwarded = false;
                    }
                    if (eMail.RelatedToId != null) {
                        if (objMap.containskey(String.valueOf(eMail.RelatedToId).substring(0, 3))) {
                            eWrap.RelatedObject = objMap.get(String.valueOf(eMail.RelatedToId).substring(0, 3));
                            eWrap.RelatedToId = eMail.RelatedToId;
                        }
                    } else {
                        eWrap.RelatedObject = '';
                        eWrap.RelatedToId = '';
                    }
                    eWrap.status = eMail.status;
                    eWrap.MessageDate = eMail.MessageDate;
                    eWrap.modifiedBy = eMail.LastModifiedBy.Name;
                    eWrap.modifiedDate = eMail.LastModifiedDate;
                    if (!String.isEmpty(eMail.RelatedTo.Name)) {
                        eWrap.RelatedTo = eMail.RelatedTo.Name;
                    } else {
                        eWrap.RelatedTo = '';
                    }
                    eWrap.HasAttachment = eMail.HasAttachment;
                    eWrap.Has_Attachment = String.valueOf(eMail.HasAttachment);
                    emialWrapper.add(eWrap);
                }
            }

            return emialWrapper;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static Map < String, String > findObjectNameFromRecordIdPrefix(String status, Boolean isDeleted, Boolean isActioned) {
        Map < String, String > objMap = new Map < String, String > ();
        try {
            List < EmailMessage > emailList = new List < EmailMessage > ();
            if (isDeleted) {
                emailList = [SELECT RelatedToId, P360_Actioned__c FROM EmailMessage WHERE RelatedToId != NULL AND P360_Actioned__c =: isActioned AND isDeleted =: isDeleted ALL ROWS];
            } else if (!isDeleted && status == '0') {
                emailList = [SELECT RelatedToId, P360_Actioned__c FROM EmailMessage WHERE RelatedToId != NULL AND P360_Actioned__c =: isActioned AND(Status = '0'
                    OR Status = '1'
                    OR Status = '2')];
            } else if (!isDeleted && status == '3') {
                emailList = [SELECT RelatedToId, P360_Actioned__c FROM EmailMessage WHERE RelatedToId != NULL AND P360_Actioned__c =: isActioned AND(Status =: status OR Status = '2'
                    OR Status = '4')];
            } else if (!isDeleted && status == '5') {
                emailList = [SELECT RelatedToId, P360_Actioned__c FROM EmailMessage WHERE RelatedToId != NULL AND P360_Actioned__c =: isActioned AND Status =: status];
            } else if (!isDeleted && status == '1') {
                emailList = [SELECT RelatedToId, P360_Actioned__c FROM EmailMessage WHERE RelatedToId != NULL AND P360_Actioned__c =: isActioned AND Status =: status];
            }
            Set < String > setOfParentIds = new Set < String > ();
            for (EmailMessage email: emailList) {
                setOfParentIds.add(String.valueOf(email.RelatedToId).substring(0, 3));
            }

            Map < String, Schema.SObjectType > gd = Schema.getGlobalDescribe();

            for (Schema.SObjectType stype: gd.values()) {

                Schema.DescribeSObjectResult r = stype.getDescribe();
                if (setOfParentIds.contains(r.getKeyPrefix())) {
                    objMap.put(r.getKeyPrefix(), r.getLabel());
                }

                /* if(prefix!=null && prefix.equals(setOfParentIds)){
                     objectName = r.getName();
                     System.debug('Object Name! ' + objectName);
                     break;
                 }*/
            }
        } catch (Exception e) {
            System.debug(e);
        }
        return objMap;
    }

    @AuraEnabled(cacheable = true)
    public static string getObjAPI(String objAPI) {
        try {
            String obiAPI;
            String keyCode = objAPI.subString(0, 3);
            Map < String, Schema.SObjectType > objMap = Schema.getGlobalDescribe();
            for (Schema.SObjectType objectInstance: objMap.values()) {
                if (objectInstance.getDescribe().getKeyPrefix() == keyCode) {
                    obiAPI = objectInstance.getDescribe().getName();
                }
            }
            return obiAPI;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static List < String > getPicklistValues(String objectName, String fieldName) {
        List < String > picklistValues = new List < String > ();
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        if (objectType != null) {
            Schema.DescribeFieldResult fieldDescribe = objectType.getDescribe().fields.getMap().get(fieldName).getDescribe();
            // if (fieldDescribe.isPicklist() && fieldDescribe.isUpdateable()) {
            List < Schema.PicklistEntry > picklistEntries = fieldDescribe.getPicklistValues();
            for (Schema.PicklistEntry entry: picklistEntries) {
                picklistValues.add(entry.getValue());
            }
            // }
        }
        return picklistValues;
    }

    public class EmailWrapper {

        @AuraEnabled public Id Id;
        @AuraEnabled public String Subject;
        @AuraEnabled public String FromAddress;
        @AuraEnabled public String ToAddress;
        @AuraEnabled public DateTime MessageDate;
        @AuraEnabled public String RelatedTo;
        @AuraEnabled public Boolean HasAttachment;
        @AuraEnabled public String Has_Attachment;
        @AuraEnabled public String modifiedBy;
        @AuraEnabled public DateTime modifiedDate;
        @AuraEnabled public Boolean replied;
        @AuraEnabled public Boolean forwarded;
        @AuraEnabled public String status;
        @AuraEnabled public String RelatedToId;
        @AuraEnabled public String RelatedObject;

    }
}