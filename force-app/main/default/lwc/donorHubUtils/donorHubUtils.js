import { ShowToastEvent } from "lightning/platformShowToastEvent";

const showToast = (title, message, variant, mode = "pester") => {
    const toast = new ShowToastEvent({
        title,
        message,
        variant,
        mode,
    });
    dispatchEvent(toast);
};

const formatDate = value => {
    const dateOptions = {
        year: "numeric", month: "numeric", day: "numeric", timeZone: 'UTC'
    };
    let dt = new Date( value );
    return new Intl.DateTimeFormat('en-US', dateOptions).format(dt);
}

export {
    showToast,
    formatDate
};