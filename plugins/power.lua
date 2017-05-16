local function is_channel_disabled( receiver )
 if not _config.disabled_channels then
  return false
 end

 if _config.disabled_channels[receiver] == nil then
  return false
 end

  return _config.disabled_channels[receiver]
end

local function enable_channel(receiver)
 if not _config.disabled_channels then
  _config.disabled_channels = {}
 end

 if _config.disabled_channels[receiver] == nil then
  return "Bot Is Offline!"
 end
 
 _config.disabled_channels[receiver] = false

 save_config()
 return "Bot Is Online!"
end

local function disable_channel( receiver )
 if not _config.disabled_channels then
  _config.disabled_channels = {}
 end
 
 _config.disabled_channels[receiver] = true

 save_config()
 return "Bot Is Offline!"
end

local function pre_process(msg, matches)
 local receiver = msg.chat_id_
 
 if is_admin1(msg) then
   if matches[1] == "power on" then
     enable_channel(receiver)
   end
 end

  if is_channel_disabled(receiver) then
   msg.content_.text_ = ""
  end

 return msg
end

local function run(msg, matches)
 local receiver = msg.chat_id_
 
 local hash = 'usecommands:'..msg.sender_user_id_..':'..msg.chat_id_
    redis:incr(hash)
 if not is_owner(msg) then
 return 'You Are Not Admin!'
 end
 if matches[2] == 'on' then
  return enable_channel(receiver)
 end
 if matches[2] == 'off' then
  return disable_channel(receiver)
 end
end

return {
 patterns = {
  "^[!/#][Pp]ower (on)",
  "^[!/#][Pp]ower (off)" }, 
 run = run,
 moderated = true,
 pre_process = pre_process
}
