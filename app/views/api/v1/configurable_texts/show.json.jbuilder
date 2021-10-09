json.text do
  json.partial! "api/v1/configurable_texts/configurable_text", :text => @text
end
