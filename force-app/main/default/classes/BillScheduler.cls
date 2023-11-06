public with sharing class BillScheduler implements Schedulable {
    public void execute(SchedulableContext ctx) {
        BillBatch billBatchInstance = new BillBatch();
        Database.executeBatch(billBatchInstance);
    }
}