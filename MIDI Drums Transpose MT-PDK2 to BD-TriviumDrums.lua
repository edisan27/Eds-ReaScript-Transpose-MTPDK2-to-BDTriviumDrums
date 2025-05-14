-- @description Remap MIDI notes from MTPower DrumKit 2 to Trivium Drums (Bogren Digital)
-- @version 1.0

function remap_notes(take, note_map)
  local _, note_count, _, _ = reaper.MIDI_CountEvts(take)
  for i = 0, note_count - 1 do
    local retval, selected, _, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
    if selected and note_map[pitch] then
      reaper.MIDI_SetNote(take, i, selected, nil, startppqpos, endppqpos, chan, note_map[pitch], vel, false)
    end
  end
  reaper.MIDI_Sort(take)
end

function main()
  local note_map = {
    [36] = 24, -- Kick
    [33] = 24, -- Kick
    [35] = 24, -- Kick
    [38] = 26, -- Snare
    [39] = 26, -- Snare
    [40] = 26, -- Snare
    [37] = 30, -- Sidestick
-- For tom there are disconnect MTPD2 have 3 toms, Trivium have 5 so it's tricky to map it
    [48] = 33, -- Tom High
    [50] = 34, -- Tom High/Mid
    [45] = 35, -- Tom Mid
    [47] = 36, -- Floor Tom Mid
    [41] = 37, -- Floor Tom
    [42] = 42, -- Hi-Hat Closed
    [62] = 42, -- Hi-Hat Closed
    [63] = 42, -- Hi-Hat Closed
    [44] = 43, -- Hi-Hat Half Open
    [61] = 43, -- Hi-Hat Half Open 2
    [46] = 46, -- Hi-Hat Open
    [60] = 46, -- Hi-Hat Open
    [65] = 48, -- Hi-Hat Pedal
    [49] = 52, -- Crash 1/L
    [57] = 54, -- Crash 2/R
    [58] = 57, -- Crash 1/L Choke
    [51] = 62, -- Ride
    [55] = 73, -- Splash
    [52] = 65, -- China
  }

  local editor = reaper.MIDIEditor_GetActive()
  if editor then
    local take = reaper.MIDIEditor_GetTake(editor)
    if reaper.TakeIsMIDI(take) then
      remap_notes(take, note_map)
    end
  else
    local num_items = reaper.CountSelectedMediaItems(0)
    for i = 0, num_items - 1 do
      local item = reaper.GetSelectedMediaItem(0, i)
      local take = reaper.GetMediaItemTake(item, 0)
      if reaper.TakeIsMIDI(take) then
        remap_notes(take, note_map)
      end
    end
  end
end

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("Transpose: MT Power DrumKit 2 to BD Trivium Drums", -1)

