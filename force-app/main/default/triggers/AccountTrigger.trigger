trigger AccountTrigger on Account (before update) {
    AccountTriggerHandler handler = new AccountTriggerHandler();

    if (Trigger.isBefore && Trigger.isUpdate) {
        handler.beforeUpdate(
            Trigger.old,
            Trigger.oldMap,
            Trigger.new,
            Trigger.newMap
        );
    } 
}