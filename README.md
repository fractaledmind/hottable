# HotTable

This application was built during the [Rails Hackathon](https://railshackathon.com) 2022. A remote hackathon for Rails developers.
We had 48 hours to build a Ruby on Rails application with the theme: **[Hotwire](https://hotwired.dev) powered Rails apps**.

## Team

* [Stephen Margheim](https://github.com/fractaledmind)
* [Joel Drapper](https://github.com/joeldrapper)
* [Marco Roth](https://github.com/marcoroth)

On the Rails Hackathon site: https://railshackathon.com/teams/18


## Description

This is an (minimal) [Airtable](https://airtable.com) clone. We left out any of the schema-building functionality and focused squarely on the data management functionality. Moreover, we pushed hard on using semantic HTML, so the table is an actual `<table>`. Within the space of data management, there are a surprising number of features however:

* Manage which fields are displayed
* Sort by any field in either direction (with multi-column sorting supported as well)
* Filter by any complex query you can imagine (nested ANDs and ORs supported with a full range of predicates)
* Group by any field (sorting in either direction, collapsing or expanding the grouped rows)
* Select rows (with clear visual indication of selected rows)
* Select all rows in the dataset (with clear visual indication of how many records are selected)
* Bulk export selected rows (with whatever display/sort/filter conditions are set on the view)
* Full pagination functionality (select number of items displayed per page, jump to a specific page, see the details of the pagination window)
* Column summaries (see information about the dataset for particular columns, with calculations based on the data-type of the column)
* X- and Y-axis scrollable table on overflow, with fixed headers, footers, and primary columns
* Quick sort, group, hide options for each column in a column header dropdown
* Inline editing of all table cells
* CRUD of views, saving your configuration of a particular combination of fields, sorts, filters, grouping, and pagination

## Built with

* [Ransack](https://activerecord-hackery.github.io/ransack/) drives the filtering and sorting. We extended Ransack to drive the fields and grouping.
* [Pagy](https://ddnexus.github.io/pagy/) drives the pagination. We applied Tailwind styling to the generated HTML.
* [Stimulus](https://stimulus.hotwired.dev/) drives the "details set" (only one `<details>` element open at a time), automatic form submission of pagination items, building complex sorts/filters, etc.
* [Turbo Drive](https://turbo.hotwired.dev/handbook/drive) allows all of the "searching" to run without a mess of updating dozens of parts of the page on any change.
* [Turbo Streams](https://turbo.hotwired.dev/handbook/streams) drive the column calculations and inline editing to allow for atomic updates of individual table cells.
* [TurboPower](https://github.com/marcoroth/turbo_power) adds a bunch of additional Turbo Stream actions and drives key parts of the inline editing flow.
* [Phlex](https://phlex.fun/) replaces `ActionView` for the HTML rendering, allowing us to build layouts, pages, and components all in pure Ruby.
* [TailwindCSS](https://tailwindcss.com/) for styling

## Demo

A demo application is running at [http://hottable-rails-hackathon.herokuapp.com](http://hottable-rails-hackathon.herokuapp.com)

## Entry

Our entry on the Rails Hackathon site: https://railshackathon.com/entries/6

## Application Screenshots

![](https://railshackathon.com/rails/active_storage/disk/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDVG9JYTJWNVNTSWhjWHBpYUc5cFltNWhlR293TUhabVltZG9jMnQwYlRNNE5tMW9jZ1k2QmtWVU9oQmthWE53YjNOcGRHbHZia2tpQVg1cGJteHBibVU3SUdacGJHVnVZVzFsUFNKRGJHVmhibE5vYjNRZ01qQXlNaTB3T1MweE9DQmhkQ0F5TXk0MU1DNHlOQ1UwTURKNExuQnVaeUk3SUdacGJHVnVZVzFsS2oxVlZFWXRPQ2NuUTJ4bFlXNVRhRzkwSlRJd01qQXlNaTB3T1MweE9DVXlNR0YwSlRJd01qTXVOVEF1TWpRbE5EQXllQzV3Ym1jR093WlVPaEZqYjI1MFpXNTBYM1I1Y0dWSklnNXBiV0ZuWlM5d2JtY0dPd1pVT2hGelpYSjJhV05sWDI1aGJXVTZDbXh2WTJGcyIsImV4cCI6IjIwMjItMDktMjBUMDA6MzY6MjQuMzI3WiIsInB1ciI6ImJsb2Jfa2V5In19--6792813562750b7b5f9e4826000a9936112498ba/CleanShot%202022-09-18%20at%2023.50.24@2x.png)

![](https://railshackathon.com/rails/active_storage/disk/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDVG9JYTJWNVNTSWhhbmR4ZW5NM2JqRjBlWFEwTVdONFluaHJNblY0Y214b2RIbDFNZ1k2QmtWVU9oQmthWE53YjNOcGRHbHZia2tpQVg1cGJteHBibVU3SUdacGJHVnVZVzFsUFNKRGJHVmhibE5vYjNRZ01qQXlNaTB3T1MweE9DQmhkQ0F5TXk0ME9TNDBPQ1UwTURKNExuQnVaeUk3SUdacGJHVnVZVzFsS2oxVlZFWXRPQ2NuUTJ4bFlXNVRhRzkwSlRJd01qQXlNaTB3T1MweE9DVXlNR0YwSlRJd01qTXVORGt1TkRnbE5EQXllQzV3Ym1jR093WlVPaEZqYjI1MFpXNTBYM1I1Y0dWSklnNXBiV0ZuWlM5d2JtY0dPd1pVT2hGelpYSjJhV05sWDI1aGJXVTZDbXh2WTJGcyIsImV4cCI6IjIwMjItMDktMjBUMDA6MzY6NDIuMDE5WiIsInB1ciI6ImJsb2Jfa2V5In19--847bbdabe69e2745ed7b444a5f9fe47c1d7ba2fa/CleanShot%202022-09-18%20at%2023.49.48@2x.png)

![](https://railshackathon.com/rails/active_storage/disk/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDVG9JYTJWNVNTSWhiWEZqY0RNeFpEaGtlaloxWVhJd1pUazJiMnhpY1docWNtMXROQVk2QmtWVU9oQmthWE53YjNOcGRHbHZia2tpQVg1cGJteHBibVU3SUdacGJHVnVZVzFsUFNKRGJHVmhibE5vYjNRZ01qQXlNaTB3T1MweE9DQmhkQ0F5TXk0ME9DNHlOaVUwTURKNExuQnVaeUk3SUdacGJHVnVZVzFsS2oxVlZFWXRPQ2NuUTJ4bFlXNVRhRzkwSlRJd01qQXlNaTB3T1MweE9DVXlNR0YwSlRJd01qTXVORGd1TWpZbE5EQXllQzV3Ym1jR093WlVPaEZqYjI1MFpXNTBYM1I1Y0dWSklnNXBiV0ZuWlM5d2JtY0dPd1pVT2hGelpYSjJhV05sWDI1aGJXVTZDbXh2WTJGcyIsImV4cCI6IjIwMjItMDktMjBUMDA6MzY6NDMuODM5WiIsInB1ciI6ImJsb2Jfa2V5In19--758878384677f9ad617181d1405f38db7fce2c87/CleanShot%202022-09-18%20at%2023.48.26@2x.png)

![](https://railshackathon.com/rails/active_storage/disk/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDVG9JYTJWNVNTSWhhbkZ0WVRSNllXaDZPR1p3TW5GMk0zSmhNblUxTVhKNWVuTnRZd1k2QmtWVU9oQmthWE53YjNOcGRHbHZia2tpQVg1cGJteHBibVU3SUdacGJHVnVZVzFsUFNKRGJHVmhibE5vYjNRZ01qQXlNaTB3T1MweE9DQmhkQ0F5TXk0ME9DNHdPU1UwTURKNExuQnVaeUk3SUdacGJHVnVZVzFsS2oxVlZFWXRPQ2NuUTJ4bFlXNVRhRzkwSlRJd01qQXlNaTB3T1MweE9DVXlNR0YwSlRJd01qTXVORGd1TURrbE5EQXllQzV3Ym1jR093WlVPaEZqYjI1MFpXNTBYM1I1Y0dWSklnNXBiV0ZuWlM5d2JtY0dPd1pVT2hGelpYSjJhV05sWDI1aGJXVTZDbXh2WTJGcyIsImV4cCI6IjIwMjItMDktMjBUMDA6MzY6NDQuODc4WiIsInB1ciI6ImJsb2Jfa2V5In19--dc994b424b8567aac23f5db3e6e5008234d4730c/CleanShot%202022-09-18%20at%2023.48.09@2x.png)

![](https://railshackathon.com/rails/active_storage/disk/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDVG9JYTJWNVNTSWhZemt6Wlc1bmEydHdNbUU0YTNodk9YQTRaR1J2WVhaa01IWnpiZ1k2QmtWVU9oQmthWE53YjNOcGRHbHZia2tpQVg1cGJteHBibVU3SUdacGJHVnVZVzFsUFNKRGJHVmhibE5vYjNRZ01qQXlNaTB3T1MweE9DQmhkQ0F5TXk0ME55NHpPU1UwTURKNExuQnVaeUk3SUdacGJHVnVZVzFsS2oxVlZFWXRPQ2NuUTJ4bFlXNVRhRzkwSlRJd01qQXlNaTB3T1MweE9DVXlNR0YwSlRJd01qTXVORGN1TXprbE5EQXllQzV3Ym1jR093WlVPaEZqYjI1MFpXNTBYM1I1Y0dWSklnNXBiV0ZuWlM5d2JtY0dPd1pVT2hGelpYSjJhV05sWDI1aGJXVTZDbXh2WTJGcyIsImV4cCI6IjIwMjItMDktMjBUMDA6MzY6NDUuNjYyWiIsInB1ciI6ImJsb2Jfa2V5In19--fe26efbfcdfeae5193e1e5e59b703e4111b5a3cf/CleanShot%202022-09-18%20at%2023.47.39@2x.png)

![](https://railshackathon.com/rails/active_storage/disk/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDVG9JYTJWNVNTSWhaVzEwTUd0Nk9HOXhNV053WVhOMmNtNXROV3R2Y1cxcmIzbGlOZ1k2QmtWVU9oQmthWE53YjNOcGRHbHZia2tpQVg1cGJteHBibVU3SUdacGJHVnVZVzFsUFNKRGJHVmhibE5vYjNRZ01qQXlNaTB3T1MweE9DQmhkQ0F5TXk0ME5pNDBOaVUwTURKNExuQnVaeUk3SUdacGJHVnVZVzFsS2oxVlZFWXRPQ2NuUTJ4bFlXNVRhRzkwSlRJd01qQXlNaTB3T1MweE9DVXlNR0YwSlRJd01qTXVORFl1TkRZbE5EQXllQzV3Ym1jR093WlVPaEZqYjI1MFpXNTBYM1I1Y0dWSklnNXBiV0ZuWlM5d2JtY0dPd1pVT2hGelpYSjJhV05sWDI1aGJXVTZDbXh2WTJGcyIsImV4cCI6IjIwMjItMDktMjBUMDA6MzY6NDYuNTM2WiIsInB1ciI6ImJsb2Jfa2V5In19--2078b4cc76e9c3d189cfad82fb6b4965557910b5/CleanShot%202022-09-18%20at%2023.46.46@2x.png)

![](https://railshackathon.com/rails/active_storage/disk/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDVG9JYTJWNVNTSWhkR2MxYkd3d09HdDVlV0YxTTNCdmNYTTVOelEwZERWdWRHczNhQVk2QmtWVU9oQmthWE53YjNOcGRHbHZia2tpQVg1cGJteHBibVU3SUdacGJHVnVZVzFsUFNKRGJHVmhibE5vYjNRZ01qQXlNaTB3T1MweE9TQmhkQ0F3TWk0d015NDBPQ1UwTURKNExuQnVaeUk3SUdacGJHVnVZVzFsS2oxVlZFWXRPQ2NuUTJ4bFlXNVRhRzkwSlRJd01qQXlNaTB3T1MweE9TVXlNR0YwSlRJd01ESXVNRE11TkRnbE5EQXllQzV3Ym1jR093WlVPaEZqYjI1MFpXNTBYM1I1Y0dWSklnNXBiV0ZuWlM5d2JtY0dPd1pVT2hGelpYSjJhV05sWDI1aGJXVTZDbXh2WTJGcyIsImV4cCI6IjIwMjItMDktMjBUMDA6MzY6NDcuMzg0WiIsInB1ciI6ImJsb2Jfa2V5In19--eb5574ee5b9d7e73e10330659b546cc64b7ff2cd/CleanShot%202022-09-19%20at%2002.03.48@2x.png)

![](https://railshackathon.com/rails/active_storage/disk/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDVG9JYTJWNVNTSWhibmMwT1c4MmVtTjBiM1pwYlhRMmRtTnVNR0p4YzNwa05Xc3hhd1k2QmtWVU9oQmthWE53YjNOcGRHbHZia2tpQVg1cGJteHBibVU3SUdacGJHVnVZVzFsUFNKRGJHVmhibE5vYjNRZ01qQXlNaTB3T1MweE9TQmhkQ0F3TWk0d05DNHdPQ1UwTURKNExuQnVaeUk3SUdacGJHVnVZVzFsS2oxVlZFWXRPQ2NuUTJ4bFlXNVRhRzkwSlRJd01qQXlNaTB3T1MweE9TVXlNR0YwSlRJd01ESXVNRFF1TURnbE5EQXllQzV3Ym1jR093WlVPaEZqYjI1MFpXNTBYM1I1Y0dWSklnNXBiV0ZuWlM5d2JtY0dPd1pVT2hGelpYSjJhV05sWDI1aGJXVTZDbXh2WTJGcyIsImV4cCI6IjIwMjItMDktMjBUMDA6MzY6NDguMTY0WiIsInB1ciI6ImJsb2Jfa2V5In19--092bcf90353630e0fa006d5fa8241addb166b4f1/CleanShot%202022-09-19%20at%2002.04.08@2x.png)
