{-# LANGUAGE OverloadedStrings #-}
module Funk.ICalendar (generateICal) where

import qualified Data.ByteString.Lazy.Char8 as BSL
import Data.Default
import Data.Map
import Data.Text.Lazy as T
import Data.Time (UTCTime)
import Funk.Map
import Text.ICalendar

generateICal :: Map String UTCTime -> BSL.ByteString
generateICal mapNameToTime = printICalendar def def {
    vcEvents = mapMap (\(name, utctime) -> (
        ( T.pack name, Just $ Right $ UTCDateTime $ utctime),
        (
            VEvent {
                veDTStamp = DTStamp {
                    dtStampValue = utctime,
                    dtStampOther = def
                },
                veUID = UID {
                    uidValue = T.pack name,
                    uidOther = def
                },
                veClass = def,
                veDTStart = Just DTStartDateTime {
                    dtStartDateTimeValue = UTCDateTime $ utctime,
                    dtStartOther = def
                },
                veCreated = Nothing,
                veDescription = Nothing,
                veGeo = Nothing,
                veLastMod = Nothing,
                veLocation = Nothing,
                veOrganizer = Nothing,
                vePriority = def,
                veSeq = def,
                veStatus = Just (ConfirmedEvent def),
                veSummary = Just (Summary {
                    summaryValue = T.pack name,
                    summaryAltRep = Nothing,
                    summaryLanguage = Nothing,
                    summaryOther = def
                }),
                veTransp = def,
                veUrl = Nothing,
                veRecurId = Nothing,
                veRRule = mempty,
                veDTEndDuration = Nothing,
                veAttach = mempty,
                veAttendee = mempty,
                veCategories = mempty,
                veComment = mempty,
                veContact = mempty,
                veExDate = mempty,
                veRStatus = mempty,
                veRelated = mempty,
                veResources = mempty,
                veRDate = mempty,
                veAlarms = mempty,
                veOther = mempty
            }
        )
    )) mapNameToTime
}