global class ActivityReminderScheduledJob implements Schedulable {
    private List<Id> taskOwnerIds;

    global ActivityReminderScheduledJob(List<Id> ownerIds) {
        this.taskOwnerIds = ownerIds;
    }

    global void execute(SchedulableContext SC) {
        List<Task> reminderTasks = new List<Task>();

        for (Id ownerId : taskOwnerIds) {
            Task reminderTask = new Task(
                Subject = 'Reminder Email',
                ActivityDate = System.today(),
                OwnerId = ownerId
            );

            reminderTasks.add(reminderTask);
        }

        insert reminderTasks;
    }
}