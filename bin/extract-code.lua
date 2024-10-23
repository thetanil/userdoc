-- Lua filter for Pandoc to extract fenced code blocks
local counter = 0

function CodeBlock(el)
    -- Increment a counter for unique filenames
    counter = counter + 1
    local language = el.classes[1] or "code" -- Use the code language for naming

    -- Set filename based on the language and counter
    local filename = string.format("%s_block_%d.%s", language, counter, language)

    -- Open file for writing
    local file = io.open(filename, "w")
    file:write(el.text) -- Write the content of the code block
    file:close()

    -- Remove the code block from the document (optional)
    -- return pandoc.Null()
    return nil

end
