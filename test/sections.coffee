
{assert} = require 'chai'

sections = require '../sections.coffee'

describe 'Markdown Sections', () ->
  test = (name, markdown, sectionsData) ->
    it name, () ->
      result = sections markdown
      assert.deepEqual result, { sections: sectionsData }


  describe 'with empty string', () ->
    test 'should return empty section array',
      ''
      []

  describe 'two paragraph without heading', () ->
    test 'should create preamble section',
      '''
      P1

      P2
      '''
      [
        {
          name: null
          text: [
            ['para', 'P1']
            ['para', 'P2']
          ]
        }
      ]

  describe 'h1', () ->
    test 'should create main section with its text as name',
      '# H1'
      [
        {name: 'H1'}
      ]
    test 'should have complex content in name as array',
      '# H1 *Bold*'
      [
        {
          name: [
            'H1 '
            ['em', 'Bold']
          ]
        }
      ]
    test 'should have simple tag content in name as array with tag as item',
      '# *Bold*'
      [
        {
          name: [
            ['em', 'Bold']
          ]
        }
      ]
    test 'should have single paragraph directly in text property',
      '''
      # H1

      p
      ''',
      [
        {
          name: 'H1'
          text: ['para', 'p']
        }
      ]
    test 'should have multiple paragraphs in text property as array',
      '''
      # H1
      p1

      p2
      ''',
      [
        {
          name: 'H1'
          text: [
            ['para', 'p1']
            ['para', 'p2']
          ]
        }
      ]

  describe 'h1 followed by h2', () ->
    test 'should create subsection',
      '''
      # H1
      ## H2
      '''
      [
        {
          name: 'H1'
          subsections: [
            {name: 'H2'}
          ]
        }
      ]
    test 'should put following paragraphs to subsection',
      '''
      # H1
      h1 para
      ## H2
      H2 para 1

      H2 para 2
      '''
      [
        {
          name: 'H1'
          text: ['para', 'h1 para']
          subsections: [
            {
              name: 'H2',
              text: [
                ['para', 'H2 para 1']
                ['para', 'H2 para 2']
              ]
            }
          ]
        }
      ]

  describe 'h2 followed by h4 and h5', () ->
    test 'should create only one subsection',
      '''
      ## H2
      #### H4
      ##### H5
      '''
      [
        {
          name: 'H2'
          subsections: [
            {
              name: 'H4'
              text: ['header', {level: 5}, 'H5']
            }
          ]
        }
      ]
    test 'should put smaller headers into subsection text',
      '''
      ## H2
      #### H4
      Para
      ##### H5
      '''
      [
        {
          name: 'H2'
          subsections: [
            {
              name: 'H4'
              text: [
                ['para', 'Para']
                ['header', {level: 5}, 'H5']
              ]
            }
          ]
        }
      ]

  describe 'h2 followed by h1', () ->
    test 'should be both main sections',
      '''
      ## H2
      # H1
      '''
      [
        {name: 'H2'}
        {name: 'H1'}
      ]

  describe 'h1 followed by h3 and h2', () ->
    test 'should place both h3 and h2 as subsections',
      '''
      # H1
      ### H3
      ## H2
      '''
      [
        {
          name: 'H1'
          subsections: [
            {name: 'H3'}
            {name: 'H2'}
          ]
        }
      ]
    test 'should put paragraphs to corresponding subsections',
      '''
      # H1
      h1 para
      ## H3
      H3 para
      ## H2
      H2 para
      '''
      [
        {
          name: 'H1'
          text: ['para', 'h1 para']
          subsections: [
            {
              name: 'H3',
              text: ['para', 'H3 para']
            }
            {
              name: 'H2',
              text: ['para', 'H2 para']
            }
          ]
        }
      ]

  describe 'h1 followed by h2 with bold text', () ->
    test 'should put parsed array as subsection name',
      '''
      # H1
      ## *H2*
      '''
      [
        {
          name: 'H1'
          subsections: [
            {
              name: [
                ['em', 'H2']
              ]
            }
          ]
        }
      ]
