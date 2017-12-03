import json

import datetime
import requests
import csv
import typing

from constants import WAVES_URL, RESULTS_URL  # make this file and set these

WAVE_KEY = 'Q_13674'
DIVISION_KEY = 'dvc'
PREVIOUS_BEST_TIME_KEY = 'Q_15920'
BIB_KEY = 'bib'

RESULTS_DATA_KEY = '#1_Goat Run'

RESULTS_KEYS = ('#1_Finished', '#2_Started')
RESULTS_BIB_INDEX = 0
RESULTS_SPLIT_1_INDEX = 5
RESULTS_SPLIT_DIFF_1_INDEX = 6
RESULTS_FINISH_TIME = 8


class WaveItem(typing.NamedTuple):
    bib: int
    wave: str
    division: str
    previous_best_time: typing.Optional[datetime.timedelta]


class ResultItem(typing.NamedTuple):
    bib: int
    time_to_hut: typing.Optional[datetime.timedelta]
    time_to_road: typing.Optional[datetime.timedelta]
    total_time: typing.Optional[datetime.timedelta]


def duration_str_to_timedelta(duration: str):
    split_duration = duration.split(':')

    if len(split_duration) == 3:
        hours, minutes, sec = map(int, split_duration)
        return datetime.timedelta(hours=hours, minutes=minutes, seconds=sec)
    else:
        return None


def transform_wave_entry_to_item(wave_entry: dict) -> WaveItem:
    previous_best_time = duration_str_to_timedelta(wave_entry[PREVIOUS_BEST_TIME_KEY])
    return WaveItem(int(wave_entry[BIB_KEY]), wave_entry[WAVE_KEY], wave_entry[DIVISION_KEY], previous_best_time)


def parse_wave_items(wave_data: typing.List[dict]) -> typing.List[WaveItem]:
    return [transform_wave_entry_to_item(entry) for entry in wave_data]


def transform_result_entry_to_item(result_entry: list) -> ResultItem:
    time_to_hut = duration_str_to_timedelta(result_entry[RESULTS_SPLIT_1_INDEX])
    split_diff_1_duration = duration_str_to_timedelta(result_entry[RESULTS_SPLIT_DIFF_1_INDEX])

    time_to_road = None

    if time_to_hut and split_diff_1_duration:
        time_to_road = time_to_hut + split_diff_1_duration

    total_time = duration_str_to_timedelta(result_entry[RESULTS_FINISH_TIME])

    return ResultItem(int(result_entry[RESULTS_BIB_INDEX]), time_to_hut, time_to_road, total_time)


def parse_results_items(results_data: typing.List[list]) -> typing.List[ResultItem]:
    return [transform_result_entry_to_item(result_entry) for result_entry in results_data]


def duration_to_seconds(duration: typing.Optional[datetime.timedelta]) -> typing.Optional[int]:
    if duration:
        return duration.seconds

    return ""


def main():
    waves_res = requests.get(WAVES_URL)

    wave_data = waves_res.json()

    wave_items = parse_wave_items(wave_data)

    bib_keyed_wave_items = {wi.bib: wi for wi in wave_items}

    results_res = requests.get(RESULTS_URL)

    results_json = results_res.content[8:-2]
    results = json.loads(results_json)

    result_items = []

    for result_type_key in RESULTS_KEYS:
        result_items += parse_results_items(results['data'][RESULTS_DATA_KEY][result_type_key])

    bib_keyed_results = {ri.bib: ri for ri in result_items}

    started_bibs = set(bib_keyed_results.keys()) & set(bib_keyed_wave_items.keys())  # bibs of those who started race

    wave_lookup = {
        "1A": 0,
        "1B": 1,
        "2A": 2,
        "2B": 3,
        "3A": 4,
        "3B": 5,
        "4A": 6,
        "4B": 7,
        "5A": 8,
        "5B": 9,
        "6A": 10,
        "6B": 11
    }

    age_division_lookup = {
        'Young': 0,
        'Open': 1,
        'Masters': 2,
        'Older': 3,
        'Oldest': 4
    }

    column_header = (
        "Bib",
        "Wave",
        "Division",
        "AgeDivision",
        "Gender",
        "PreviousBestTime",
        "TimeToHut",
        "TimeToRoad",
        "TotalTime"
    )

    with open('goat2017.csv', 'w') as csvfile:
        goatwriter = csv.writer(csvfile)
        goatwriter.writerow(column_header)

        for bib in started_bibs:
            result_item: ResultItem = bib_keyed_results[bib]
            wave_item: WaveItem = bib_keyed_wave_items[bib]

            gender = wave_item.division[-1]
            age_division = wave_item.division[:-1]

            goatwriter.writerow(
                (
                    bib,
                    wave_lookup[wave_item.wave],
                    wave_item.division,
                    age_division_lookup[age_division],
                    1 if gender == "M" else 0,
                    duration_to_seconds(wave_item.previous_best_time),
                    duration_to_seconds(result_item.time_to_hut),
                    duration_to_seconds(result_item.time_to_road),
                    duration_to_seconds(result_item.total_time)
                )
            )


if __name__ == '__main__':
    main()
