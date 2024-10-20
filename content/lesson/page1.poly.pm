#lang pollen

◊(define-meta title     "Page 1")

◊h2{Tailwind Typography Example}

◊div[#:class "mt-4 text-blue-400"]{
    ◊span[#:class "block md:hidden"]{SM and below (<768px)}
    ◊span[#:class "hidden md:block lg:hidden"]{MD (768px-1023px)}
    ◊span[#:class "hidden lg:block xl:hidden"]{LG (1024px-1279px)}
    ◊span[#:class "hidden xl:block 2xl:hidden"]{XL (1280px-1535px)}
    ◊span[#:class "hidden 2xl:block"]{2XL (≥1536px)}
}

Until now, trying to style an article, document, or blog post with Tailwind has been a tedious task that required a keen eye for typography and a lot of complex custom CSS.

By default, Tailwind removes all of the default browser styling from paragraphs, headings, lists and more. This ends up being really useful for building application UIs because you spend less time undoing user-agent styles, but when you ◊em{really are} just trying to style some content that came from a rich-text editor in a CMS or a markdown file, it can be surprising and unintuitive.

We get lots of complaints about it actually, with people regularly asking us things like:

◊blockquote{
Why is Tailwind removing the default styles on my ◊code{h1} elements? How do I disable this? What do you mean I lose all the other base styles too?
}

We hear you, but we're not convinced that simply disabling our base styles is what you really want. You don't want to have to remove annoying margins every time you use a ◊code{p} element in a piece of your dashboard UI. And I doubt you really want your blog posts to use the user-agent styles either — you want them to look ◊em{awesome}, not awful.

The ◊code{@tailwindcss/typography} plugin is our attempt to give you what you ◊em{actually} want, without any of the downsides of doing something stupid like disabling our base styles.

It adds a new ◊code{prose} class that you can slap on any block of vanilla HTML content and turn it into a beautiful, well-formatted document:

◊pre{
<article class="prose"> <h1>Garlic bread with cheese: What the science tells us</h1> <p> For years parents have espoused the health benefits of eating garlic bread with cheese to their children, with the food earning such an iconic status in our culture that kids will often dress up as warm, cheesy loaf for Halloween. </p> <p> But a recent study shows that the celebrated appetizer may be linked to a series of rabies cases springing up around the country. </p> <!-- ... --> </article> }

For more information about how to use the plugin and the features it includes, ◊a{read the documentation}.

◊hr{}

◊h2{What to expect from here on out}

What follows from here is just a bunch of absolute nonsense I've written to dogfood the plugin itself. It includes every sensible typographic element I could think of, like ◊strong{bold text}, unordered lists, ordered lists, code blocks, block quotes, ◊em{and even italics}.

It's important to cover all of these use cases for a few reasons:

◊ol{
    ◊li{We want everything to look good out of the box.}
    ◊li{Really just the first reason, that's the whole point of the plugin.}
    ◊li{Here's a third pretend reason though a list with three items looks more realistic than a list with two items.}
}

Now we're going to try out another header style.

◊h3{Typography should be easy}

So that's a header for you — with any luck if we've done our job correctly that will look pretty reasonable.

Something a wise person once told me about typography is:

◊blockquote{
Typography is pretty important if you don't want your stuff to look like trash. Make it good then it won't be bad.
}

It's probably important that images look okay here by default as well:

Now I'm going to show you an example of an unordered list to make sure that looks good, too:

◊ul{
    ◊li{So here is the first item in this list.}
    ◊li{In this example we're keeping the items short.}
    ◊li{Later, we'll use longer, more complex list items.}
}

And that's the end of this section.

◊h2{What if we stack headings?}

◊h3{We should make sure that looks good, too.}

Sometimes you have headings directly underneath each other. In those cases you often have to undo the top margin on the second heading because it usually looks better for the headings to be closer together than a paragraph followed by a heading should be.

◊h3{When a heading comes after a paragraph …}

When a heading comes after a paragraph, we need a bit more space, like I already mentioned above. Now let's see what a more complex list would look like.

◊ul{
    ◊li{◊strong{I often do this thing where list items have headings.}

    For some reason I think this looks cool which is unfortunate because it's pretty annoying to get the styles right.

    I often have two or three paragraphs in these list items, too, so the hard part is getting the spacing between the paragraphs, list item heading, and separate list items to all make sense. Pretty tough honestly, you could make a strong argument that you just shouldn't write this way.}

    ◊li{◊strong{Since this is a list, I need at least two items.}

    I explained what I'm doing already in the previous list item, but a list wouldn't be a list if it only had one item, and we really want this to look realistic. That's why I've added this second list item so I actually have something to look at when writing the styles.}

    ◊li{◊strong{It's not a bad idea to add a third item either.}

    I think it probably would've been fine to just use two items but three is definitely not worse, and since I seem to be having no trouble making up arbitrary things to type, I might as well include it.}
}

After this sort of list I usually have a closing statement or paragraph, because it kinda looks weird jumping right to a heading.

◊h2{Code should look okay by default.}

I think most people are going to use ◊a{highlight.js} or ◊a{Prism} or something if they want to style their code blocks but it wouldn't hurt to make them look ◊em{okay} out of the box, even with no syntax highlighting.

Here's what a default ◊code{tailwind.config.js} file looks like at the time of writing:
◊pre{
module.exports = {
purge: [],
theme: {
extend: {},
},
variants: {},
plugins: [],
}
}

Hopefully that looks good enough to you.

◊h3{What about nested lists?}

Nested lists basically always look bad which is why editors like Medium don't even let you do it, but I guess since some of you goofballs are going to do it we have to carry the burden of at least making it work.

◊ol{
    ◊li{◊strong{Nested lists are rarely a good idea.}
    ◊ul{
        ◊li{You might feel like you are being really "organized" or something but you are just creating a gross shape on the screen that is hard to read.}
        ◊li{Nested navigation in UIs is a bad idea too, keep things as flat as possible.}
        ◊li{Nesting tons of folders in your source code is also not helpful.}
    }
    }
    ◊li{◊strong{Since we need to have more items, here's another one.}
    ◊ul{
        ◊li{I'm not sure if we'll bother styling more than two levels deep.}
        ◊li{Two is already too much, three is guaranteed to be a bad idea.}
        ◊li{If you nest four levels deep you belong in prison.}
    }
    }
    ◊li{◊strong{Two items isn't really a list, three is good though.}
    ◊ul{
        ◊li{Again please don't nest lists if you want people to actually read your content.}
        ◊li{Nobody wants to look at this.}
        ◊li{I'm upset that we even have to bother styling this.}
    }
    }
}
The most annoying thing about lists in Markdown is that ◊code{<li>} elements aren't given a child ◊code{<p>} tag unless there are multiple paragraphs in the list item. That means I have to worry about styling that annoying situation too.

◊ul{
    ◊li{
        ◊strong{For example, here's another nested list.}

        But this time with a second paragraph.

        ◊ul{
            ◊li{These list items won't have ◊code{<p>} tags}
            ◊li{Because they are only one line each}
        }
    }
    ◊li{
        ◊strong{But in this second top-level list item, they will.}
        This is especially annoying because of the spacing on this paragraph.

        ◊ul{
            ◊li{
                As you can see here, because I've added a second line, this list item now has a ◊code{<p>} tag.

                This is the second line I'm talking about by the way.
            }

            ◊li{Finally here's another list item so it's more like a list.}
        }
    }
    ◊li{A closing list item, but with no nested list, because why not?}
}

And finally a sentence to close off this section.

◊h2{There are other elements we need to style}

I almost forgot to mention links, like ◊a{this link to the Tailwind CSS website}. We almost made them blue but that's so yesterday, so we went with dark gray, feels edgier.
We even included table styles, check it out:

◊table{
    ◊thead{
        ◊tr{
            ◊th{Wrestler}
            ◊th{Origin}
            ◊th{Finisher}
        }
    }
    ◊tbody{
        ◊tr{
            ◊td{Bret "The Hitman" Hart}
            ◊td{Calgary, AB}
            ◊td{Sharpshooter}
        }
        ◊tr{
            ◊td{Stone Cold Steve Austin}
            ◊td{Austin, TX}
            ◊td{Stone Cold Stunner}
        }
        ◊tr{
            ◊td{Randy Savage}
            ◊td{Sarasota, FL}
            ◊td{Elbow Drop}
        }
        ◊tr{
            ◊td{Vader}
            ◊td{Boulder, CO}
            ◊td{Vader Bomb}
        }
        ◊tr{
            ◊td{Razor Ramon}
            ◊td{Chuluota, FL}
            ◊td{Razor's Edge}
        }
    }
}

We also need to make sure inline code looks good, like if I wanted to talk about ◊code{<span>} elements or tell you the good news about ◊code{@tailwindcss/typography}.

◊h3{Sometimes I even use ◊code{code} in headings}

Even though it's probably a bad idea, and historically I've had a hard time making it look good. This ◊em{"wrap the code blocks in backticks"} trick works pretty well though really.

Another thing I've done in the past is put a ◊code{code} tag inside of a link, like if I wanted to tell you about the ◊a{◊code{tailwindcss/docs}} repository. I don't love that there is an underline below the backticks but it is absolutely not worth the madness it would require to avoid it.

◊h4{We haven't used an ◊code{h4} yet}

But now we have. Please don't use ◊code{h5} or ◊code{h6} in your content, Medium only supports two heading levels for a reason, you animals. I honestly considered using a ◊code{before} pseudo-element to scream at you if you use an ◊code{h5} or ◊code{h6}.

We don't style them at all out of the box because ◊code{h4} elements are already so small that they are the same size as the body copy. What are we supposed to do with an ◊code{h5}, make it ◊em{smaller} than the body copy? No thanks.

◊h3{We still need to think about stacked headings though.}

◊h4{Let's make sure we don't screw that up with ◊code{h4} elements, either.}

Phew, with any luck we have styled the headings above this text and they look pretty good.

Let's add a closing paragraph here so things end with a decently sized block of text. I can't explain why I want things to end that way but I have to assume it's because I think things will look weird or unbalanced if there is a heading too close to the end of the document.

What I've written here is probably long enough, but adding this final sentence can't hurt.