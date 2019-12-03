$(function() {
  $('[data-channel-subscribe="room"]').each(function(index, element) {
    var $element = $(element),
        room_id = $element.data('room-id')
        messageTemplate = $('[data-role="message-template"]');

    $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000)        

    App.cable.subscriptions.create(
      {
        channel: "RoomChannel",
        room: room_id
      },
      {
        received: function(data) {
          // if (data.link) {
          // } else {
            var content = messageTemplate.children().clone(true, true);
            var img = $(`<div style="width:100%;height:0;padding-bottom:100%;position:relative;"><iframe src="${data.link}" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div>`)
            console.log(data.link)
            content.find('[data-role="user-avatar"]').attr('src', data.user_avatar_url);
            content.find('[data-role="message-text"]').text(data.message);
            content.find('[data-role="message-date"]').text(data.updated_at);
            $element.append(content);
            $element.append(img);
            $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000);
          // }
        }
      }
    );
  });
});