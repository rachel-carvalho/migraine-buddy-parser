inspect = {}

// http://en.wikipedia.org/wiki/ANSI_escape_code#graphics
inspect.colors = {
  'bold' : [1, 22],
  'italic' : [3, 23],
  'underline' : [4, 24],
  'inverse' : [7, 27],
  'white' : [37, 39],
  'grey' : [90, 39],
  'black' : [30, 39],
  'blue' : [34, 39],
  'cyan' : [36, 39],
  'green' : [32, 39],
  'magenta' : [35, 39],
  'red' : [31, 39],
  'yellow' : [33, 39]
};

function stylizeWithColor(str, color) {
  if (color) {
    return '\u001b[' + inspect.colors[color][0] + 'm' + str +
           '\u001b[' + inspect.colors[color][1] + 'm';
  } else {
    return str;
  }
}

module.exports = stylizeWithColor
