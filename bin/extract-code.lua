-- Lua filter for Pandoc to extract fenced code blocks
local counter = 0
local output_folder = "build/srcextract"
local code_blocks = {}

function CodeBlock(el)
    -- Increment a counter for unique filenames
    counter = counter + 1
    local language = el.classes[1] or "code" -- Use the code language for naming

    -- make output_folder if it doesn't exist
    os.execute("mkdir -p " .. output_folder)

    -- Log the language to the console
    print("Processing code block with language: " .. language)

    -- Set filename based on the language and counter
    local filename = string.format("%s/%s_block_%d.%s", output_folder, language, counter, language)

    -- Open file for writing
    local file = io.open(filename, "w")
    if file then
        file:write(el.text) -- Write the content of the code block
        file:close()
        print("Successfully wrote to file: " .. filename)
    else
        print("Error: Could not open file for writing: " .. filename)
    end

    -- Collect the content of the code block
    table.insert(code_blocks, el.text)

    -- Remove the code block from the document
    return pandoc.RawBlock("markdown", "")
end

function Pandoc(doc)
    -- Output the collected code blocks as plain text
    return pandoc.Pandoc({pandoc.Plain {pandoc.Str(table.concat(code_blocks, "\n\n"))}})
end
