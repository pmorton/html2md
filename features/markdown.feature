Feature: Markdown
  We need to convert basic HTML to markdown

  Scenario: Create a H Rule (HR) element
    * HTML <hr/>
    * I say parse
    * The markdown should be (********\n)

  Scenario: Create a hard break (BR) element
    * HTML <br/>
    * I say parse
    * The markdown should be (  \n)

  Scenario: Paragraph (P) elements should be a single hard return
    * HTML <p>
    * I say parse
    * The markdown should be (\n\n)

  Scenario: Link (a href=) elements should should convert
    * HTML <a href="/some/link.html"> Link </a>
    * I say parse
    * The markdown should be ([ Link ](/some/link.html))

  Scenario: Other ancors should be ignored
    * HTML <a name="link"> Link </a>
    * I say parse
    * The markdown should be ( Link )

  Scenario: Ancors should reset after being used once
    * HTML <a href="/some/link.html"> Link </a> <a name="link"> Link </a>
    * I say parse
    * The markdown should be ([ Link ](/some/link.html) Link )

  Scenario: Other (a) elements should be ignored
    * HTML <a> Text Text </a>
    * I say parse
    * The markdown should be ( Text Text ) 

  Scenario: An order list
    * HTML <ol><li>First</li><li>Second</li><ol>
    * I say parse
    * The markdown should be (\n  1. First\n  2. Second\n\n)

  Scenario: An un-order list
    * HTML <ul><li>First</li><li>Second</li><ul>
    * I say parse
    * The markdown should be (\n  - First\n  - Second\n\n) 

  Scenario: Complex List
    * HTML <ul><li>First</li><li> <ol><li>First<ul><li>First</li><li>Second</li></ul></li><li>Second</li> </ol>Second</li><ul>
    * I say parse
    * The markdown should be (\n  - First\n  - \n    1. First\n      - First\n      - Second\n    2. Second\nSecond\n\n)

  Scenario: Emphasis (em) element
    * HTML <em>Emphasis</em>
    * I say parse
    * The markdown should be (_Emphasis_)

  Scenario: Strong (strong) element
    * HTML <strong>Emphasis</strong>
    * I say parse
    * The markdown should be (**Emphasis**)

  Scenario: Pre (pre) element
    * HTML <pre>This is some preformatted code</pre>
    * I say parse
    * The markdown should be (\n```\nThis is some preformatted code\n```\n) 

  Scenario: Other HTML Elements (div) should be ignored
    * HTML <div>This is in a div</div>
    * I say parse
    * The markdown should be (This is in a div)

  Scenario: Other HTML Elements (span) should be ignored  
    * HTML <span>This is in a span</span>
    * I say parse
    * The markdown should be (This is in a span) 

  Scenario: Character data should not have new lines  
    * HTML <p>This is character data    \n\n\n\n</p>  
    * I say parse
    * The markdown should be (This is character data \n\n) 

  Scenario: First level headers 
    * HTML <h1>This is a H1 Element</h1>
    * I say parse
    * The markdown should be (\nThis is a H1 Element\n====================\n\n) 

  Scenario: Second level headers 
    * HTML <h2>This is a H2 Element</h2>
    * I say parse
    * The markdown should be (\nThis is a H2 Element\n--------------------\n\n)

  Scenario: New lines should be treated as space 
    * HTML <p>Word 1\nWord 2<\p>
    * I say parse
    * The markdown should be (Word 1 Word 2\n\n)

  Scenario: Third level headers 
    * HTML <h3>This is a H3 Element</h3>
    * I say parse
    * The markdown should be (\n### This is a H3 Element\n\n)

  Scenario: Full File Conversion 
    * File (./features/assets/test.html)
    * I say parse
    * The mardown should be equal to (./features/assets/test.md)
