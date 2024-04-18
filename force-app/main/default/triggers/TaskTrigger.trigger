trigger TaskTrigger on Task (before insert, before update) {
    Id targetQueueId = 'P360_DA_Advisory_Queue';

    // Get the members of the specified queue
    Set<Id> queueMembers = new Set<Id>();
    for (GroupMember groupMember : [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :targetQueueId]) {
        queueMembers.add(groupMember.UserOrGroupId);
    }

    // Check if the task type
    for (Task task : Trigger.new) {
        if (task.Type == 'Define hierarchy') {
            if (!queueMembers.contains(task.OwnerId)) {
                task.addError('You can only assign a task with type "Define hierarchy" to members of the specified queue.');
            }
        }
    }
}