local i18n = require("i18n")

propT = {
   state = {
      validT = { LTS_stack = 1, development_stack = 1 },
      displayT = {
         LTS_stack         = { short = "(LTS)", full_color = false,  color = "black", doc = 'Long-Term Support, modules available for up to two years after release. system software permitting', },
         development_stack = { short = "(dev)", full_color = false,  color = "red",   doc = 'Development stack, modules available until an equivalent is available in a LTS software stack', },
      },
   },
   lmod = {
      validT = { sticky = 1 },
      displayT = {
         sticky = { short = "(S)",  color = "magenta",    doc = i18n("StickyM"), }
      },
   },
}