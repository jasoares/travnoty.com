$().ready(function () {
    var sel = $('.welcome #pre_subscription_hub');
    sel.addClass('dim');
    sel.focus(function () {
        $(this).removeAttr('class');
    });
    sel.focusout(function () {
        var selected = $('option:selected', this).val();
        if (selected == '0') {
            $(this).addClass('dim');
        }
    });
});