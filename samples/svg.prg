function Main()

  TEMPLATE
      <svg width="100%" height="100%">
        <defs>
           <filter x="0" y="0" width="1" height="1" id="solid">
             <feFlood flood-color="blue"/>
             <feComposite in="SourceGraphic" operator="xor" />
           </filter>
        </defs>
        <text filter="url(#solid)" x="20" y="50" font-size="20">solid background</text>
      </svg>
  ENDTEXT

return nil
