# frozen_string_literal: true

# Markdownlint style file
# File syntax: Ruby (Markdownlint Style DSL)
#

# Refs:
#    Ruby version
#        Config: https://github.com/markdownlint/markdownlint/blob/master/docs/configuration.md
#        Styles: https://github.com/markdownlint/markdownlint/blob/master/docs/creating_styles.md
#        Rules: https://github.com/markdownlint/markdownlint/blob/master/docs/RULES.md
#    JS version (modeled after the Ruby version)
#        https://github.com/DavidAnson/markdownlint/blob/master/doc/Rules.md
#
#
# Many of the defaults used by Markdownlint are chosen because of how renderers
# interpret Markdown. The defaults are chosen for the greatest compatability and
# confidence in proper rendering of the Markdown; for text-only viewing, it is
# less relevant.

# Enabled all rules
#
# This is makes many of the rules defined below, where they are just being
# enabled and running with the defaults, unnecessary. They've been left in for
# explanatory purposes.
all

# MD001 - Header levels should only increment by one level at a time
rule 'MD001'

# MD002 - First header should be a top level header
rule 'MD002'

# MD003 - Header style
# Default: always use the same header style of any of the allowed header styles
#
# Headers should use the `#` ('atx') style headers
rule 'MD003', style: :atx

# MD004 - Unordered list style
# Default: always use the same character (any one of `*`,`+`,`-`)
#
# Do not force a single unordered list character, we should be using them to
# visually indicate nested lists. Since this rule cannot support validating
# our usage, we are disabling it.
exclude_rule 'MD004'

# MD005 - Inconsistent indentation for list items at the same level
# Default: don't allow inconsistent indentation for list items
rule 'MD005'

# MD006 - Start bulleted lists at the beginning of the line
rule 'MD006'

# MD007 - Unordered list indentation
# Default: 2 spaces
#
# Use 4 spaces because using 2 doesn't always render a sublist.
rule 'MD007', indent: 4

# No rule MD008

# MD009 - Trailing spaces
# Default: trailing spaces not allowed
rule 'MD009'

# MD010 - Hard tabs
# Default: hard tabs not allowed
rule 'MD010'

# MD011 - Reversed link syntax
# Default: alert when link syntax seems to be reversed
#          (the `[]` and `()` are reversed)
rule 'MD011'

# MD012 - Multiple consecutive blank lines
# Default: No multiple consecutive blank lines
rule 'MD012'

# MD013 - Line length
# Default: Max 80 characters per line
#
# Set line length limit to 120 characters (default: 80 characters)
rule 'MD013', line_length: 120, code_blocks: false

# MD014 - Dollar signs used before commands without showing output
# Default: No dollars signs before shell commands w/o showing shell output
rule 'MD014'

# No rule MD015 to MD017

# MD018 - No space after hash on atx style header
# Default: Must have space after header style
rule 'MD018'

# MD019 - Multiple spaces after hash on atx style header
# Default: No multiple spaces after hash in header
rule 'MD019'

# MD020 - No space inside hashes on closed atx style header
# Default: Must have space before closing hash in closed atx style headers
#
# We don't use closed ATX style headers
rule 'MD020'

# MD021 - Multiple spaces inside hashes on closed atx style header
# Default: No multiple spaces before closing hash in closed atx style headers
#
# We don't use closed ATX style headers
rule 'MD021'

# MD022 - Headers should be surrounded by blank lines
# Default: Must have a blank line above and below headers
rule 'MD022' # headers should be surrounded by blank lines

# MD023 - Headers must start at the beginning of the line
rule 'MD023'

# MD024 - Multiple headers with the same content
# Default: No multiple headers with same content, no duplicate header text
rule 'MD024', allow_different_nesting: true

# MD025 - Multiple top level headers in the same document
# Default: The is onlt one level 1 header; it's the title of the document
rule 'MD025'

# MD026 - Trailing punctuation in header
# Default: No trailling punctuation in headers
rule 'MD026'

# MD027 - Multiple spaces after blockquote symbol
# Default: Only a single spaces after blockquote symbol
rule 'MD027'

# MD028 - Blank line inside blockquote
# Default: Blockquote right next to each other must have text between them
rule 'MD028'

# MD029 - Ordered list item prefix
# Default:
#
# ordered list item prefix, should be ordered
rule 'MD029', style: :ordered

# MD030 - Spaces after list markers
# Default: Only one space character after a list marker
rule 'MD030'

# MD031 - Fenced code blocks should be surrounded by blank lines
# Default: Fenced code blocks ("```") must have a blank line above and below
rule 'MD031'

# MD032 - Lists should be surrounded by blank lines
# Default: Lists must have a blank line above and below the list (not each item)
rule 'MD032'

# MD033 - Inline HTML
# Default: No raw HTML
rule 'MD033'

# MD034 - Bare URL used
# Default: No bare URLs
rule 'MD034'

# MD035 - Horizontal rule style
# Default: Be consistent, use only one of `---`, `- - -`, `***`, or `* * *`
#
# We want to enforce `---`
rule 'MD035', style: '---'

# MD036 - Emphasis used instead of a header
# Default: Do not use emphasis (bold, italic, etc) as header, use actual headers
rule 'MD036'

# MD037 - Spaces inside emphasis markers
# Default: No leading/trailing spaces inside emphasis markers
rule 'MD037'

# MD038 - Spaces inside code span elements
# Default: No leading/trailing spaces inside code markers ("`")
rule 'MD038'

# MD039 - Spaces inside link text
# Default: No leading/trailing spaces inside link text ("[]")
rule 'MD039'

# MD040 - Fenced code blocks should have a language specified
# Default: Fenced code blocks ("```") must have a language specified
rule 'MD040'

# MD041 - First line in file should be a top level header
# Default: First line in file must be a top level header
rule 'MD041'

# Rule MD042 to MD045, and MD047 are only supported by the JavScript version

# # MD042 - No empty links
# # Default: Links URLs cannot be empty; empty fragments (`#`) are still empty
# rule 'MD042'

# # MD043 - Required heading structure
# # Default: disabled
# #
# # This requires headings from a predetermined list (`headings` array).
# rule 'MD043'

# # MD044 - Proper names should have the correct capitalization
# # Default: names: nil, code_blocks: true
# #
# # This preforms a case-insensitive search for srtings from the `names` array.
# # then checks capatilization of those strings against the element from `names`
# rule 'MD044'

# # MD045 - Images should have alternate text (alt text)
# # Default: Alt text is required for all images
# rule 'MD045'

# MD046 - Code block style
# Default: Always used fenced code blocks ("```")
rule 'MD046'

# # MD047 - Files should end with a single newline character
# # Default: Requires newline at end of file
# rule 'MD047'

