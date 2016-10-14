backlogUrl = 'https://XXXXX.backlog.jp/'

module.exports = (robot) ->
  robot.router.post "/room/:room", (req, res) ->
    room = req.params.room
    body = req.body

    console.log 'body type = ' + body.type
    console.log 'room = ' + room

    try
      switch body.type
          when 1
              label = '課題が追加'
          when 2, 3
              label = '課題が更新'
          when 4
              label = '課題が削除'
          else
              return


      url = "#{backlogUrl}view/#{body.project.projectKey}-#{body.content.key_id}"

      if body.content.comment?.id?
          url += "#comment-#{body.content.comment.id}"

      message = "[info][title]Backlogより[/title]"
      message += "#{body.createdUser.name}さんによって#{label}されました\n"
      message += "[#{body.project.projectKey}-#{body.content.key_id}]"
      message += "#{body.content.summary}\n"

      if body.content.comment?.content?
          message += "#{body.content.comment.content}\n"
      message += "#{url}[/info]"

      console.log 'message = ' + message

      if message?
          robot.messageRoom room, message
          res.end "OK"
      else
          robot.messageRoom room, "Backlog integration error."
          res.end "Error"
    catch error
      robot.send
      res.end "Error"
