
BlockEvents.broken(event => {
  const pos = event.block.pos
  const id = `${pos.x},${pos.y},${pos.z}`

    // Remove WAN IPs
    const wan = global.wanAssignments.get(id)
    if (wan) {
      global.wanAssignments.delete(id)
      delete global.ipRegistry[wan]
      delete global.messageQueue[wan]
    }

    // Remove LAN IPs
    const group = global.peripheralGroups[id]
    if (group) {
      for (const computerId in group) {
        const lan = group[computerId]
        delete global.lanRegistry[lan]
        delete global.lanConnections[lan]
        delete global.messageQueue[lan]
      }
      delete global.peripheralGroups[id]
    }
    // Remove domains registered to this WAN IP
    for (const domain in global.domainRegistry) {
      if (global.domainRegistry[domain].ip === wan) {
        delete global.domainRegistry[domain]
      }
    }
})
BlockEvents.rightClicked(event => {
  const { player, block } = event;

  const pos = block.getPos()
  const id = `${pos.x},${pos.y},${pos.z}`
  // Replace with the actual block ID
  if (block.id == 'the_network:network_per') {
    const wan = global.wanAssignments.get(id) || 'Unknown WAN';

    player.tell(Text.red('WAN: ').append(Text.green(wan)));
  }
});
