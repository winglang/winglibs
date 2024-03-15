function matchesPattern(event, pattern) {
    console.log("event", event);
  for (let key in pattern) {
      // Check if key exists in the event
      if (!event.hasOwnProperty(key)) {
          return false;
      }

      // If the pattern value is an object (but not an array), recursively check for match
      if (typeof pattern[key] === 'object' && !Array.isArray(pattern[key])) {
          if (!matchesPattern(event[key], pattern[key])) {
              return false;
          }
      }

      // If the pattern value is an array, handle different comparison cases
      if (Array.isArray(pattern[key])) {
          let matchFound = false;
          for (let value of pattern[key]) {
              if (typeof value === 'object') {
                  // Handle special comparison objects
                  if (value.hasOwnProperty('prefix') && event[key].startsWith(value.prefix)) {
                      matchFound = true;
                      break;
                  } else if (value.hasOwnProperty('suffix') && event[key].endsWith(value.suffix)) {
                      matchFound = true;
                      break;
                  } else if (value.hasOwnProperty('equals-ignore-case') && event[key].toLowerCase() === value['equals-ignore-case'].toLowerCase()) {
                      matchFound = true;
                      break;
                  } else if (value.hasOwnProperty('wildcard') && new RegExp("^" + value['wildcard'].split("*").join(".*") + "$").test(event[key])) {
                      matchFound = true;
                      break;
                  }
              } else if (event[key] === value || (value === "" && event[key] === "")) {
                  // Basic value match or empty string match
                  matchFound = true;
                  break;
              }
          }
          if (!matchFound) {
              return false;
          }
      }
  }
  return true;
}

module.exports = {
    matchesPattern
}