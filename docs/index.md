---
layout: default
---

**Harbour for the web is finally here**. It took years to understand what we really need and how to implement it. But the Harbour for the web momentum, the xbase developers web momentum, has **finally arrived**.

mod Harbour is an **extension module** for Apache that provides full support to **execute PRGs and HRBs files from the web**.

If you are a **Windows developer**, you can build the web **from your Windows 10 bash** and then simply **run your PRGs on Edge or Chrome** powered by **Apache on the bash** using the **mod Harbour extension**.

# Windows 10 bash support

The Windows 10 WSL (Windows SubSystem for Linux) lets you use Ubuntu 18.04 (about 200 mb) from your Windows 10 bash and install Apache and MySQL server on it. Detailed instructions are provided in the [mod Harbour repo wiki](https://github.com/FiveTechSoft/mod_harbour/wiki).

## OSX support

The mod Harbour is already available for the Macs: https://github.com/FiveTechSoft/mod_harbour/tree/master/osx
With an easy to use installer that sets up everything for you.

### Linux support

mod Harbour versions for Ubuntu and CentOS 7 are already available. Use Ubuntu from your Windows 10 bash, code your PRGs from
Windows 10 using for favorite source code editor and run the PRGs from Edge or Chrome. Apache server and MySQL server from Ubuntu give you all you need. The perfect environment for creating web applications using Harbour in records time.

```c
// typicall Harbour PRG running on the web
#xcommand ? <cText> => AP_RPuts( <cText> )

function Main()

   ? "Hello world"
   
return nil   
```

#### Header 4

*   This is an unordered list following a header.
*   This is an unordered list following a header.
*   This is an unordered list following a header.

##### Header 5

1.  This is an ordered list following a header.
2.  This is an ordered list following a header.
3.  This is an ordered list following a header.

###### Header 6

| head1        | head two          | three |
|:-------------|:------------------|:------|
| ok           | good swedish fish | nice  |
| out of stock | good and plenty   | nice  |
| ok           | good `oreos`      | hmm   |
| ok           | good `zoute` drop | yumm  |

### There's a horizontal rule below this.

* * *

### Here is an unordered list:

*   Item foo
*   Item bar
*   Item baz
*   Item zip

### And an ordered list:

1.  Item one
1.  Item two
1.  Item three
1.  Item four

### And a nested list:

- level 1 item
  - level 2 item
  - level 2 item
    - level 3 item
    - level 3 item
- level 1 item
  - level 2 item
  - level 2 item
  - level 2 item
- level 1 item
  - level 2 item
  - level 2 item
- level 1 item

### Small image

![Octocat](https://assets-cdn.github.com/images/icons/emoji/octocat.png)

### Large image

![Branching](https://guides.github.com/activities/hello-world/branching.png)


### Definition lists can be used with HTML syntax.

<dl>
<dt>Name</dt>
<dd>Godzilla</dd>
<dt>Born</dt>
<dd>1952</dd>
<dt>Birthplace</dt>
<dd>Japan</dd>
<dt>Color</dt>
<dd>Green</dd>
</dl>

```
Long, single-line code blocks should not wrap. They should horizontally scroll if they are too long. This line should be long enough to demonstrate this.
```

```
The final element.
```

