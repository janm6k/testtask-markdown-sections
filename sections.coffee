
md = require('markdown').markdown

class SectionParser

  constructor: (@nodes) ->
    # reference to last main section or subsection
    # all following content should go its `text` property
    @currentSection = null
    # reference to current open main section
    @mainSection = null
    @mainSectionLevel = null
    # reference to current open subsection
    @subsection = null
    @subsectionLevel = null
    # position in tree where content of @currentSection starts
    @contentStart = 0
    # position in nodes which we are currently considering
    @currentPosition = 0
    # output array holding the main sections
    @mainSections = []

  parse: ->
    while @currentPosition < @nodes.length
      node = @nodes[@currentPosition]
      if node[0] == 'header'
        level = node[1].level
        @processHeader node[1].level,
          if node.length == 3 && !Array.isArray(node[2])
            node[2]
          else
            node.slice 2
      @currentPosition++
    @closeCurrentSection()
    @mainSections


  processHeader: (level, headingContent) ->
    if @mainSectionLevel == null || level <= @mainSectionLevel
      @closeCurrentSection()
      @mainSectionLevel = level
      @subsectionLevel = null
      @mainSection = @currentSection = {name: headingContent}
      @mainSections.push @currentSection
    else if @subsectionLevel == null || level <= @subsectionLevel
      @closeCurrentSection()
      @subsectionLevel = level
      @currentSection = { name: headingContent }
      unless 'subsections' of @mainSection
        @mainSection.subsections = []
      @mainSection.subsections.push @currentSection


  closeCurrentSection: ->
    if @currentPosition != 0
      if @currentSection == null
        @currentSection = {name: null}
        @mainSections.push @currentSection

      if @contentStart == @currentPosition - 1
        # place single node directly
        @currentSection.text = @nodes[@contentStart]
      else if @contentStart != @currentPosition
        @currentSection.text = @nodes.slice @contentStart
    @contentStart = @currentPosition + 1


parseSections = (markdown) ->
  tree = md.parse markdown

  # empty text is returned as ['markdown']
  if tree.length == 1
    return {
      sections: []
    }

  parser = new SectionParser(tree.slice(1))

  {
    sections: parser.parse()
  }

module.exports = parseSections
