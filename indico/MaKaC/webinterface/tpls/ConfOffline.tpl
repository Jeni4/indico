<% from indico.util.date_time import format_datetime %>

<div>

  <div class="groupTitle">
    <span class="icon-clipboard" aria-hidden="true"></span>
    <span>${ _("Task list")}<span>
  </div>

  <table class="i-table" style="width: auto">
      <tr class="i-table" style="font-weight: bold; text-align: center; background: #EEE">  
        <td class="offlineTask">${ _("Id")}</td>
        <td class="offlineTask">${ _("Requested by")}</td>
        <td class="offlineTask">${ _("Request Time")}</td>
        <td class="offlineTask">${ _("Creation Time")}</td>
        <td class="offlineTask">${ _("Status")}</td>
        <td class="offlineTask">${ _("Link")}</td>
      </tr>
    % for task in offlineTasks:
      % if task.conference.getId() == confId:
        <tr class="i-table">
          <td class="offlineTask">${task.id}</td>
          <td class="offlineTask">${task.avatar.getStraightFullName()}</td>
          <td class="offlineTask">${format_datetime(task.requestTime)}</td>
          <td class="offlineTask">${format_datetime(task.creationTime) if task.creationTime else ""}</td>
          <td class="offlineTask"><div class="abstractStatus offlineTasks${task.status}">${task.getOfflineEventStatusLabel()}</div></td>
          <td class="offlineTask">
              % if task.file:
                <a href="${task.getDownloadLink()}" class="i-button">${ _("Download")}</a>
              % endif
          </td>
        </tr>
        % endif
    % endfor
    </table>
  <div style="margin-top: 20px">${_("Above list contains offline conferences generated in the past. <br>If you want to generate your own copy of the conference click 'Generate' button below.")}</div>
  <input style="margin-top: 20px; font-weight: bold" class="i-button"  id="generateButton" name="generateButton" value="${ _('Generate')}" type="button"/>
<div>
</div>

<script type="text/javascript">
var taskAddedPopup = new AlertPopup($T("Task successfully added to generation queue"),$T("You will get email notification when offline version of the event will be generated and ready to download"), 
  function () {
    window.location.reload();
  }); 

$("#generateButton").click(function(){
    new ConfirmPopup($T("Offline version generation"),$T("Are you sure you want to generate offline version of this event?<br>Remember that this is a heavy operation especially for big events so make sure that this is necessary before you continue!"), function(confirmed) {
        if(confirmed) {
            var killProgress = IndicoUI.Dialogs.Util.progress($T("Adding generation request task..."));
            indicoRequest('event.offline.addTask',
                    { confId: "${confId}",
                      avatarId: "${avatarId}" },
                      function(result, error) {
                          if (!error) {
                            killProgress();
                            if (result) {
                              taskAddedPopup.open();
                            }
                          } else {
                            killProgress();
                            IndicoUtil.errorReport(error);
                          }
                    });
        }
    }).open();
    return false;
    });
</script>
