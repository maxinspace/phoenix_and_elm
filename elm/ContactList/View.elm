module ContactList.View exposing (indexView)

import Contact.View exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Messages exposing (..)
import Model exposing (..)


indexView : Model -> Html Msg
indexView model =
    div
        [ id "home_index" ]
        [ viewContent model ]

viewContent : Model -> Html Msg
viewContent model =
    case model.contactList of
        NotRequested ->
            [ text "" ]

        Requesting ->
            [ searchSection model
            , warningMessage
                "fa fa-spin fa-cog fa-2x fa-fw"
                "Searching for contacts"
                (text "")
            ]

        Failure error ->
            [ warningMessage
                "fa fa-meh-o fa-stack-2x"
                error
                (text "")
            ]

        Success page ->
            [ searchSection model
            , paginationList page
            , div
                []
                [ contactsList model page ]
            , paginationList page
            ]


contactsList : Model -> Html Msg
contactsList model =
    if model.contactList.total_entries > 0 then
        model.contactList.entries
            |> List.map contactView
            |> div [ class "cards-wrapper" ]

    else
        let classes = classList [ ( "warning", True ) ]
        in
            div
                [ classes ]
                [
                    span
                    [ class "fa-stack" ]
                    [ i [ class "fa fa-meh-o fa-stack-2x" ] [] ]

                ,   h4
                    []
                    [ text "No contacts found" ]
                ]


searchSection : Model -> Html Msg
searchSection model =
    let
        totalEntries = model.contactList.total_entries
        contactWord = if totalEntries == 1 then "contact" else "contacts"
        headerText = if totalEntries == 0 then "" else (toString totalEntries) ++ " " ++ contactWord ++ " found"
    in
        div
            [ class "filter-wrapper" ]
            [ div
                [ class "overview-wrapper" ]
                [ h3
                    []
                    [ text headerText ]
                ]
            , div
                [ class "form-wrapper" ]
                [ Html.form
                    [ onSubmit HandleFormSubmit ]
                    [ input
                        [ type_ "search"
                        , placeholder "Search contacts..."
                        , value model.search
                        , onInput HandleSearchInput
                        ]
                        []
                    ]
                ]
            ]


paginationList : Model -> Html Msg
paginationList model =
    let
        pageNumber = model.contactList.page_number
        totalPages = model.contactList.total_pages
    in
        List.range 1 totalPages
            |> List.map (paginationLink pageNumber)
            |> ul [ class "pagination" ]


paginationLink : Int -> Int -> Html Msg
paginationLink currentPage page =
    let
        classes =
            classList [ ( "active", currentPage == page ) ]
    in
        li
            []
            [ a
                [ classes
                , onClick <| Paginate page
                ]
                []
            ]

warningMessage : String -> String -> Html Msg -> Html Msg
warningMessage iconClasses message content =
    div
        [ class "warning" ]
        [ span
            [ class "fa-stack" ]
            [ i [ class iconClasses ] [] ]
        , h4
            []
            [ text message ]
        , content
        ]
