/*

The MIT License

Copyright (c) 2008 Alexander Kellett

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

#import <Cocoa/Cocoa.h>
#import "CalendarStore/CalendarStore.h"

CalCalendar* findCalendar(NSString *calName) {
	NSArray *calendars = [[CalCalendarStore  defaultCalendarStore] calendars];
	for (CalCalendar *cal in calendars) {
		if ([cal.title isEqualTo:calName]) {
			return cal;
		}
	}
	return nil;

}
int main(int argc, char *argv[])
{
	CalCalendar *shadow = findCalendar(@"Shadow");
	CalCalendar *daily = findCalendar(@"@inbox");
	if (!daily) {
		NSLog(@"Couldn't find @inbox calendar, please set this calendar up before using this application.");
		return 1;
	}
	CalCalendarStore *calStore = [CalCalendarStore defaultCalendarStore];
	NSDate *midnightLastNight = [NSDate dateWithNaturalLanguageString:@"today at midnight" locale:nil];
	NSDate *justBeforeMidnightTonight = [midnightLastNight addTimeInterval:(60*60*24 - 1)];
	NSPredicate *predicate = [CalCalendarStore eventPredicateWithStartDate: midnightLastNight
		endDate:justBeforeMidnightTonight calendars:[NSArray arrayWithObject:shadow]];
	NSArray *events = [calStore eventsWithPredicate:predicate];
	for (CalEvent *event in events) {
		CalTask *newTask = [CalTask task];
		newTask.calendar = daily;
		newTask.title = event.title;
		newTask.dueDate = [NSDate date];
		NSError *error;
		[[CalCalendarStore defaultCalendarStore] saveTask:newTask error:&error];
		if (error) {
			NSLog(@"Error while saving task.");
			return 1;
		}
	}
	return 0;
}
