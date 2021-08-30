/*
*  gen_utils.h
*
*  This file is part of TinyHttpServer
*
*  TinyHttpServer is free software; you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation; either version 2 of the License, or
*  (at your option) any later version.
*
*  TinyHttpServer is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with TinyHttpServer; if not, write to the Free Software
*  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  US
*
*  Author:	Antonino Calderone, <acaldmail@gmail.com>
*  CO-Author:	Kai Li, <recarelee@gmail.com>
*
*  This work was updated and extended by Kai Li, for the purpose of demostrating
*  the final project of CSE775 - Distributed Object.
*/


/// \file gen_utils.h
/// \brief Collection of general purpose utilities


// -----------------------------------------------------------------------------


#ifndef __GEN_UTILS_H__
#define __GEN_UTILS_H__


// -----------------------------------------------------------------------------


#include <chrono>
#include <regex>
#include <string>
#include <time.h>

#include "os_dep.h"

namespace gen_utils {


// ------------------------------------------------------------------------


using timeout_t = std::chrono::system_clock::duration;


/**
* Convert a timeval object into standard duration object
*
* @param d  Duration
* @param tv Timeval source object
*/
void convert_duration_in_timeval(const timeout_t& d, timeval& tv);


// ------------------------------------------------------------------------


/**
 * Get the system time, corrected for the local time zone
 * Time format is "DoW Mon dd hh:mm:ss yyyy"
 * Example "Thu Sep 19 10:03:50 2013"
 *
 * @param local_time String will contain the time
 */
void get_local_time(std::string& local_time);


// ------------------------------------------------------------------------


/**
 * Compare two time in mktime format, corrected for the local time zone
 *
 * t1 > t2, return true, otherwise return false 
 */
bool compare_time(time_t& t1, time_t& t2);


// ------------------------------------------------------------------------


/**
 * Calculate the MD5 hash of the given string first, then construct the searching
 * path by placing the first heximal character as the first level sub-
 * directory, placing the second and third character as the second level
 * sub-direcroty and appending the request_uri. 
 * @param path will contain the local searching path 
 */
void get_path_by_md5sum(std::string& str, std::string& path);


// ------------------------------------------------------------------------


/**
 * Convert the string ASICC time to mktime, corrected for the local time zone
 * Input time format is "DoW Mon dd hh:mm:ss yyyy"
 * Example "Thu Sep 19 10:03:50 2013"
 *
 * @param t will contain the time in mktime format
 */
void str2time(std::string& time, time_t& t);


// ------------------------------------------------------------------------


/**
 * Get the system time, corrected for the local time zone
 * Time format is "DoW Mon dd hh:mm:ss yyyy"
 * Example "Thu Sep 19 10:03:50 2013"
 *
 * @return the string will contain the time
 */
inline std::string get_local_time()
{
    std::string lt;
    get_local_time(lt);
    return lt;
}


// ------------------------------------------------------------------------


/**
 *  Removes any instances of character c if present at the end of the string s
 *
 *  @param s The input / ouput string
 *  @param c Searching character to remove
 */
void remove_last_ch_if(std::string& s, char c);


// ------------------------------------------------------------------------


/**
 *  Returns file attributes of filename.
 *
 *  @param filename String containing the path of existing file
 *  @param date_time Time of last modification of file
 *  @param ext File extension or "." if there is no any
 *  @return true if operation successfully completed, false otherwise
 */
bool file_stat(const std::string& filename, std::string& date_time,
    std::string& ext, size_t& fsize);


// ------------------------------------------------------------------------


/**
 *  Returns file size
 *
 *  @param filename String containing the path of existing file/directory
 *  @return file size if operation successfully completed, -1 otherwise
 */
inline size_t file_size(const std::string& filename)
{
    std::string date_time;
    std::string ext;
    size_t fsize;
    bool ok = file_stat(filename, date_time, ext, fsize);
    return ok ? fsize : -1;
}


// ------------------------------------------------------------------------


/**
*  Returns true if file/directory filename exists
*
*  @param filename String containing the path of existing file/directory
*  @return true if operation successfully completed, false otherwise
*/
inline bool file_exist(const std::string& filename)
{
    std::string date_time;
    std::string ext;
    size_t fsize;
    return file_stat(filename, date_time, ext, fsize);
}


// ------------------------------------------------------------------------


/**
 * Split text line in a vector of tokens.
 *
 * @param line The string to split
 * @param tokens The vector of splitted tokens
 * @param sep The separator string used to recognize the tokens
 *
 * @return true if operation successfully completed, false otherwise
 */
bool split_line_in_tokens(const std::string& line,
    std::vector<std::string>& tokens, const std::string& sep);


} // namespace gen_utils


#endif // __GEN_UTILS_H__
