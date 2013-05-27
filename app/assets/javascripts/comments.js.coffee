jQuery ->
  markdownSettings = {
    previewParserPath: '/markitup/preview'
    onShiftEnter:	{keepDefault:false, openWith:'\n\n'}
    markupSet: [
      {name:'Bold', key:'B', openWith:'**', closeWith:'**'}
      {name:'Italic', key:'I', openWith:'_', closeWith:'_'}
      {separator:'---------------' }
      {name:'Bulleted List', openWith:'- ' }
      {name:'Numeric List', openWith: (markItUp) -> markItUp.line+'. ' }
      {separator:'---------------' }
      {
        name:'Picture', key:'P',
        replaceWith:'![[![Alternative text]!]]([![Url:!:http://]!] "[![Title]!]")'
      },
      {
        name:'Link', key:'L', openWith:'[',
        closeWith:']([![Url:!:http://]!] "[![Title]!]")',
        placeHolder:'Your text to link here...'
      },
      {separator:'---------------'}
      {name:'Quotes', openWith:'> '}
      {name:'Code Block / Code', openWith:'(!(```\n|!|`)!)', closeWith:'(!(\n```|!|`)!)'}
      {separator:'---------------'}
      {name:'Preview', call:'preview', className:"preview"}
    ]
  }

  $('#comment_body').markItUp(markdownSettings)
