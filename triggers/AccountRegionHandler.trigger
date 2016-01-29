trigger AccountRegionHandler on Account (after insert) {
    List<SObject> regionObjectsToAdd = new List<SObject>();
    if (Trigger.isInsert) {
        for (Account a : Trigger.new) {
            System.debug('Region = '+a.Region__c);
            if (a.Region__c != NULL) {
                String regionTypeName = 'Account_' + a.Region__c + '__c';
                SObject regionObj = Schema.getGlobalDescribe().get(regionTypeName).newSObject();
                regionObj.put('Account__c', a.Id);
                System.debug(regionObj);
                regionObjectsToAdd.add(regionObj);
            }
        }
    }
    System.debug(regionObjectsToAdd.size() + ' region objects to add.');
    System.debug(regionObjectsToAdd);
    insert regionObjectsToAdd;
}