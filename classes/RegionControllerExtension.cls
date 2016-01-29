public class RegionControllerExtension {
	private final Account acc;
    public sObject custom {public get; private set;}
    public List<String> fields {public get; private set;}
    
    public RegionControllerExtension(ApexPages.StandardController stdc) {
        this.acc = (Account)stdc.getRecord();
        fields = new List<String>();
        String queryString = 'SELECT ';
        if (acc.Region__c != null) {
            List<String> regionTypeName = new List<String>();
            regionTypeName.add('Account_'+acc.Region__c+'__c');
            Schema.DescribeSObjectResult res = Schema.describeSObjects(regionTypeName)[0];

            // This generates a map of field tokens.
            Map<String, Schema.SObjectField> fieldMap = res.fields.getMap();
            for (String fieldName : fieldMap.keySet()) {
                // If the field is custom, add it to the query.
                if (fieldMap.get(fieldName).getDescribe().isCustom()) {
                    queryString = queryString + fieldName + ', ';
                    // And add it to the set of editable fields, unless it's the Account__c
                    // field
                    if (fieldName != 'Account__c') {
                    	fields.add(fieldName);
                    }
                }
            }
            
            queryString = queryString + 'Id FROM '+regionTypeName[0]+ 
                ' WHERE Account__c = \''+acc.id+'\' LIMIT 1';
            System.debug(queryString);

            custom = Database.query(queryString);
        }
    }    
}