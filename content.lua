local content = {}

function content.getText()
    return "Hello test asdfasdf!"
end

function content.getHelpText()
    return {
        "Edit content.lua to see hot reloading in action!",
        "Window is resizable - try changing the size!",

    }
end

return content 