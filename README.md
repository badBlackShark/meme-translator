# Meme Translator

All this requires to run is a `config.yml` placed in `/lib` with up to three entries. The file should look something like this:
```yaml
secret: 'your api key for Microsoft Translator'
location: 'the location your key is for. Leave empty for global keys'
passes: 5 # The number of passes through random languages the program should make before going (back) to English.

```
If `passes` exceeds the number of languages the translator has available, all of them will be chosen. Out of the box, a new language will be chosen for each pass for any one phrase. If you want repeats, you're going to need to slightly adjust the way the program selects the random languages.

After this, simply run `ruby ./lib/meme-translator.rb <path/to/json-file>` (assuming you're running from the projects main directory), and the contents of your file will be automatically updated.

While the program is running, it will log every step that it does in the console, so you can see exactly what is happening. Please be aware that for long files execution can take quite a while.
