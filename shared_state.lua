local shared_state = {
    selected_events = {}  -- Table to store selected events
}

-- Add an event to the selected list
function shared_state.addSelectedEvent(event)
    -- Check if it's already selected
    for i, selected in ipairs(shared_state.selected_events) do
        if selected.id == event.id then
            -- Already selected, so do nothing
            return false
        end
    end
    
    -- Add to selected events
    table.insert(shared_state.selected_events, event)
    print("Added event to selection: " .. event.title)
    return true
end

-- Remove an event from the selected list
function shared_state.removeSelectedEvent(eventId)
    for i, event in ipairs(shared_state.selected_events) do
        if event.id == eventId then
            table.remove(shared_state.selected_events, i)
            print("Removed event from selection: " .. event.title)
            return true
        end
    end
    return false
end

-- Check if an event is selected
function shared_state.isEventSelected(eventId)
    for _, event in ipairs(shared_state.selected_events) do
        if event.id == eventId then
            return true
        end
    end
    return false
end

-- Get all selected events
function shared_state.getSelectedEvents()
    return shared_state.selected_events
end

return shared_state 