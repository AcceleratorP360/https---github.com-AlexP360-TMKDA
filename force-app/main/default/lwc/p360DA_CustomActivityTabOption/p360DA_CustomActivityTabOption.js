import { LightningElement,api } from 'lwc';
export default class P360DA_CustomActivityTabOption extends LightningElement {

    @api value;

    taskVar = false;
    eventVar = false;
    emailVar = false;
    callVar = false;

    connectedCallback() {
        console.log('fun child called');
        console.log('value data ==',JSON.stringify(this.value));
        //   console.log('value ==',this.value.icone);
        if(this.value.icone == 'task')
            {
                this.taskVar = true;
            }
            else if(this.value.icone == 'log_a_call')
            {
                this.callVar = true;
            }
            else if(this.value.icone == 'email')
            {
                this.emailVar = true;
            }
            else if(this.value.icone == 'event')
            {
                this.eventVar = true;
                // console.log('startdate=', this.convertDate(this.value.startDate));
                // console.log('endDate=', this.convertDate(this.value.endDate));
                // this.value = {...this.value,['startDate']:this.convertDate(this.value.startDate),['endDate']:this.convertDate(this.value.endDate)};
                // console.log('value====dd==',JSON.stringify(this.value));
            //  this.value.endDate = this.convertDate(this.value.endDate);
            }
    }


    convertDate(date)
    {
        const utcDate = new Date(date);
        const indiaDate = new Date(utcDate);
        const romeOptions = { timeZone: 'Europe/Rome', year: 'numeric', month: 'numeric', day: 'numeric', hour: 'numeric', minute: 'numeric', hour12: true };

    const romeDate = indiaDate.toLocaleString('en-US', romeOptions);
        return romeDate;
    }
}