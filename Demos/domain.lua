local dns = peripheral.find("domain_server")
local modem = peripheral.find("network_modem")
if not dns or not modem then error("Missing required peripherals") end

-- Your fixed target (domain or IP)
local target = "192.168.0.3"
local port = 11325
local ip = modem.getIp("lan")
if ip.value == nil then
  printError("fail Grabing IP")
else
  print("IP = ", ip.value)
end
sleep(1)
-- Register this domain
local domain = "zerodrones.owner"
local a = dns.register(domain)
if a.status then
  print(" Domain registered:", domain)
else
  printError("Fail: ", a.error)
end

print(" Relay ready all messages will go to:", target)
while true do
  local reply = dns.poll()
  if reply.status  == true then
    print("["..tostring(reply.port).."] Got message: " .. reply.message )
    if reply.port == port then
      print(" Forwarding to " .. target)
      modem.sendLan(target, reply.message)
    else
      print("Invalid Port So Skiping")
    end
  elseif not reply.error == "No Message" then
    print("Error: ".. tostring(reply.error))
  end
  sleep(.1)
end

